# Set the latest LTS version of node as the global default
mise use -g node@lts

# Install global tools via mise's npm backend
# （node のバージョンと独立して管理されるため、切替時の再インストールが不要）
mise use -g npm:firebase-tools
