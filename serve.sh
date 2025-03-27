#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Jekyll development server...${NC}"
echo -e "${YELLOW}Site will be available at:${NC} http://localhost:4000"

# Run Jekyll with the development config
bundle exec jekyll serve --config _config.yml,_config_dev.yml --livereload

exit 0 