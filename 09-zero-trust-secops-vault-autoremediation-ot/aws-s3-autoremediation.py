# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
"""
Event-Driven Cloud Security Posture Management (CSPM) Auto-Remediation
Triggered via AWS EventBridge on CloudTrail S3 Bucket Permission Modification
Restores S3 Block Public Access within < 5 Seconds
"""
import json
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)
s3_client = boto3.client("s3")


def lambda_handler(event: dict, context) -> dict:
    detail = event.get("detail", {})
    event_name = detail.get("eventName", "")
    bucket_name = detail.get("requestParameters", {}).get("bucketName")

    if not bucket_name:
        return {"status": "skipped", "reason": "No bucketName in CloudTrail event"}

    logger.warning(
        "CSPM Alert: Detected %s on bucket '%s'. Enforcing BlockPublicAccess immediately.",
        event_name,
        bucket_name,
    )

    s3_client.put_public_access_block(
        Bucket=bucket_name,
        PublicAccessBlockConfiguration={
            "BlockPublicAcls": True,
            "IgnorePublicAcls": True,
            "BlockPublicPolicy": True,
            "RestrictPublicBuckets": True,
        },
    )

    return {
        "status": "remediated",
        "bucket": bucket_name,
        "trigger_event": event_name,
        "public_access_blocked": True,
    }
