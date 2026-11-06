# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# STEP 2: Install Sysmon & Enroll Wazuh Agent on Windows Test Endpoint
# =====================================================================
$ErrorActionPreference = 'Stop'

Invoke-WebRequest -Uri "https://download.sysinternals.com/files/Sysmon.zip" -OutFile "$env:TEMP\Sysmon.zip"
Expand-Archive -Path "$env:TEMP\Sysmon.zip" -DestinationPath "$env:TEMP\Sysmon" -Force
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml" -OutFile "$env:TEMP\Sysmon\sysmonconfig.xml"
& "$env:TEMP\Sysmon\Sysmon64.exe" -accepteula -i "$env:TEMP\Sysmon\sysmonconfig.xml"

# Append Sysmon EventChannel Ingestion to Wazuh Agent ossec.conf
$OssecConf = "C:\Program Files (x86)\ossec-agent\ossec.conf"
$SysmonBlock = @"
<ossec_config>
  <localfile>
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
</ossec_config>
"@
Add-Content -Path $OssecConf -Value $SysmonBlock
Restart-Service -Name WazuhSvc
