#!/bin/bash
# wordpress-claude-stack setup script
# Usage: curl -fsSL https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/scripts/setup.sh | bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 wordpress-claude-stack setup${NC}"
echo ""

# Check if we're in a WordPress project
if [ ! -f "wp-config.php" ] && [ ! -f "style.css" ] && [ ! -f "functions.php" ] && [ ! -f "composer.json" ]; then
    echo "⚠️  No WordPress project detected. Continuing anyway..."
fi

# Download files
echo -e "${GREEN}📥 Downloading CLAUDE.md...${NC}"
curl -fsSL -o CLAUDE.md https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/CLAUDE.md

echo -e "${GREEN}📥 Downloading .cursorrules...${NC}"
curl -fsSL -o .cursorrules https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/.cursorrules

echo -e "${GREEN}📥 Downloading Copilot instructions...${NC}"
mkdir -p .github
curl -fsSL -o .github/copilot-instructions.md https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/.github/copilot-instructions.md

echo -e "${GREEN}📥 Downloading skills...${NC}"
mkdir -p skills
for skill in generate-plugin generate-cpt generate-block generate-rest-api generate-woo-extension; do
    curl -fsSL -o "skills/${skill}.md" "https://raw.githubusercontent.com/mvtandas/wordpress-claude-stack/main/skills/${skill}.md"
done

echo ""
echo -e "${GREEN}✅ wordpress-claude-stack installed!${NC}"
echo ""
echo "Files added:"
echo "  📄 CLAUDE.md"
echo "  📄 .cursorrules"
echo "  📄 .github/copilot-instructions.md"
echo "  📁 skills/ (5 generation skills)"
echo ""
echo "Next steps:"
echo "  1. Open your project in Cursor or Claude Code"
echo "  2. AI tools will automatically read the config files"
echo "  3. Try: /generate-plugin my-awesome-plugin"
