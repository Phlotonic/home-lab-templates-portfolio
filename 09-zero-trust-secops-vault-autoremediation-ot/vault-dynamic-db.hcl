# =====================================================================
# Required Notice: Copyright (c) 2026 Adam Dryden (Phlotonic) (https://github.com/Phlotonic)
# Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.
# Commercial or corporate use requires a paid license — see COMMERCIAL-LICENSE.md.
# =====================================================================
# HashiCorp Vault Dynamic Database Secrets Policy & Ephemeral Role Config
# =====================================================================

path "database/creds/prod-app-ephemeral-readonly" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Dynamic Role Definition (1-Hour Default TTL, Automatic Revocation on Lease Expiry)
role "prod-app-ephemeral-readonly" {
  db_name              = "core-postgres-prod"
  default_ttl = "1h"
  max_ttl     = "24h"
  creation_statements  = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
  ]
  revocation_statements = [
    "REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM \"{{name}}\";",
    "DROP ROLE IF EXISTS \"{{name}}\";"
  ]
}
