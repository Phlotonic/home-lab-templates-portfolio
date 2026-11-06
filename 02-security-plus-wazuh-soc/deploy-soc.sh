#!/usr/bin/env bash
# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# STEP 1: Provision All-in-One Wazuh SIEM Server on Ubuntu 24.04 LTS VM
# =====================================================================
set -euo pipefail
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
sudo bash ./wazuh-install.sh -a
sudo tar -O -xvf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt
