#!/usr/bin/env bash
# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Live Chaos Failover Test & Free Tier Teardown Script (AWS SAA-C03)
# =====================================================================
set -euo pipefail

# 1. Deploy the 3-Tier Stack
aws cloudformation deploy \
  --stack-name saa-c03-three-tier-ha \
  --template-file aws-three-tier-ha.yaml \
  --parameter-overrides DBMasterPassword="StrongRdsPassword#2026!"

ALB_DNS=$(aws cloudformation describe-stacks --stack-name saa-c03-three-tier-ha --query "Stacks[0].Outputs[0].OutputValue" -o text)

# 2. Deliberately Terminate One Running Web Instance to Trigger ASG Self-Healing
VICTIM_ID=$(aws autoscaling describe-auto-scaling-instances --query "AutoScalingInstances[0].InstanceId" -o text)
echo "Terminating EC2 Instance: $VICTIM_ID and polling ALB availability..."
aws ec2 terminate-instances --instance-ids "$VICTIM_ID"

for i in {1..30}; do
  curl -s "http://$ALB_DNS" | tr -d '\n'
  echo " [Probe $i]"
  sleep 5
done

# 3. Verify Replacement Instance Provisioned by Auto Scaling Group
aws autoscaling describe-scaling-activities --max-items 5

# 4. Tear Down All Resources to Remain Within AWS Free Tier
aws cloudformation delete-stack --stack-name saa-c03-three-tier-ha
