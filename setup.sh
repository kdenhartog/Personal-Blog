#!/bin/bash

# Colors for pretty output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Setting up local development environment for Jekyll blog...${NC}"

# Check if RVM is installed
if ! command -v rvm &> /dev/null; then
    echo -e "${RED}RVM not found. Please install RVM first:${NC}"
    echo -e "${YELLOW}\curl -sSL https://get.rvm.io | bash -s stable${NC}"
    echo -e "After installing RVM, run 'source ~/.rvm/scripts/rvm' and try again."
    exit 1
fi

# Make sure RVM is loaded
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]]; then
    source "/usr/local/rvm/scripts/rvm"
else
    echo -e "${RED}Could not find RVM scripts. Please ensure RVM is properly installed.${NC}"
    exit 1
fi

RUBY_VERSION="3.2.2"
GEMSET_NAME="personal_blog"
PROJECT_DIR=$(pwd)

# Create or update .ruby-version file
echo "$RUBY_VERSION" > .ruby-version

# Create or update .ruby-gemset file
echo "$GEMSET_NAME" > .ruby-gemset

# Install Ruby version if not already installed
if ! rvm list | grep -q "$RUBY_VERSION"; then
    echo -e "${YELLOW}Ruby $RUBY_VERSION not found. Installing...${NC}"
    # Install required dependencies for building Ruby
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${YELLOW}Installing dependencies for macOS...${NC}"
        # Check if Homebrew is installed
        if command -v brew &> /dev/null; then
            brew install openssl readline libyaml
        else
            echo -e "${RED}Homebrew not found. It's recommended to install Homebrew for required dependencies.${NC}"
            echo -e "${YELLOW}You can install it with: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${NC}"
        fi
    fi
    
    # Install Ruby with specific flags for macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        rvm install $RUBY_VERSION --with-openssl-dir=$(brew --prefix openssl)
    else
        rvm install $RUBY_VERSION
    fi
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install Ruby $RUBY_VERSION.${NC}"
        echo -e "${YELLOW}Trying alternative installation method...${NC}"
        rvm install $RUBY_VERSION --disable-binary
        if [ $? -ne 0 ]; then
            echo -e "${RED}All installation methods failed. Please try installing manually with:${NC}"
            echo -e "${YELLOW}rvm install $RUBY_VERSION --with-openssl-dir=\$(brew --prefix openssl)${NC}"
            exit 1
        fi
    fi
fi

# Use the correct Ruby version and create a gemset
echo -e "${YELLOW}Setting up Ruby $RUBY_VERSION with gemset $GEMSET_NAME...${NC}"
rvm use $RUBY_VERSION@$GEMSET_NAME --create
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to set Ruby version and gemset. Please check RVM installation.${NC}"
    exit 1
fi

echo -e "${GREEN}Using Ruby $(ruby -v)${NC}"

# Check if Bundler is installed
if ! gem list -i bundler &> /dev/null; then
    echo -e "${YELLOW}Bundler not found. Installing...${NC}"
    gem install bundler
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install Bundler. Please try installing it manually with 'gem install bundler'.${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}Bundler found.${NC}"

# Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
bundle install
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to install dependencies.${NC}"
    exit 1
fi

echo -e "${GREEN}Dependencies installed successfully!${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo -e "${YELLOW}To run the site locally, use:${NC} ./serve.sh"

# Return to the project directory
cd "$PROJECT_DIR"

exit 0 