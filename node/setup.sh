# Install volta
curl https://get.volta.sh | bash

# Set up Volta environment
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Install the latest LTS version of node
volta install node

# Install packages globally
npm install -g firebase-tools@latest
