#!/bin/bash
#
# Automated GitHub Repository Upload Script
# Kosovo Credit Market Research
# Author: Premtim Morina
#

set -e  # Exit on any error

echo "======================================================================"
echo "  Kosovo Credit Market Research - GitHub Upload Script"
echo "======================================================================"
echo ""
echo "Repository: kosovo-credit-market-research"
echo "Author: Premtim Morina"
echo "Institution: Universiteti Haxhi Zeka"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Repository directory
REPO_DIR="/home/claude/kosovo-credit-market-research"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}ERROR: Git is not installed${NC}"
    echo "Install with: sudo apt install git -y"
    exit 1
fi

# Navigate to repository
cd "$REPO_DIR" || exit 1
echo -e "${GREEN}✓${NC} Located repository directory"

# Check if already initialized
if [ -d ".git" ]; then
    echo -e "${YELLOW}!${NC} Repository already initialized"
    echo "Do you want to re-initialize? (y/N): "
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        rm -rf .git
        echo -e "${GREEN}✓${NC} Cleaned existing git data"
    fi
fi

# Initialize git repository
if [ ! -d ".git" ]; then
    echo ""
    echo "Initializing git repository..."
    git init
    echo -e "${GREEN}✓${NC} Git repository initialized"
fi

# Configure git (prompt for user info)
echo ""
echo "======================================================================"
echo "  Git Configuration"
echo "======================================================================"
echo ""
echo "Current git config:"
echo "  Name: $(git config --global user.name 2>/dev/null || echo 'Not set')"
echo "  Email: $(git config --global user.email 2>/dev/null || echo 'Not set')"
echo ""

# Prompt for git config if not set
if [ -z "$(git config --global user.name)" ]; then
    echo "Enter your name (default: Premtim Morina): "
    read -r git_name
    git_name=${git_name:-"Premtim Morina"}
    git config --global user.name "$git_name"
    echo -e "${GREEN}✓${NC} Git user name configured"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo "Enter your email: "
    read -r git_email
    if [ -n "$git_email" ]; then
        git config --global user.email "$git_email"
        echo -e "${GREEN}✓${NC} Git user email configured"
    fi
fi

# Stage all files
echo ""
echo "======================================================================"
echo "  Staging Files"
echo "======================================================================"
echo ""
git add .
echo -e "${GREEN}✓${NC} All files staged for commit"

# Show status
echo ""
echo "Files to be committed:"
git status --short

# Create commit
echo ""
echo "======================================================================"
echo "  Creating Commit"
echo "======================================================================"
echo ""

COMMIT_MESSAGE="Initial commit: Kosovo Credit Market Research

- Paper 1: Understanding Credits and Personal Credit Market in Kosovo
- Paper 2: Credits, Kosovo Market, and Major Financial Case Study
- Bilingual documentation (English/Albanian)
- Academic license (CC BY-NC-SA 4.0)
- Comprehensive market analysis and regulatory framework study
- Academic Year 2024/25, Universiteti Haxhi Zeka"

git commit -m "$COMMIT_MESSAGE"
echo -e "${GREEN}✓${NC} Commit created successfully"

# Set main branch
git branch -M main
echo -e "${GREEN}✓${NC} Branch set to 'main'"

# Check if remote already exists
if git remote | grep -q "origin"; then
    echo -e "${YELLOW}!${NC} Remote 'origin' already exists"
    echo "Current remote: $(git remote get-url origin)"
    echo "Do you want to update it? (y/N): "
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        git remote remove origin
        echo -e "${GREEN}✓${NC} Removed existing remote"
    fi
fi

# Add GitHub remote
if ! git remote | grep -q "origin"; then
    GITHUB_REPO="https://github.com/PremtimMorina/kosovo-credit-market-research.git"
    git remote add origin "$GITHUB_REPO"
    echo -e "${GREEN}✓${NC} GitHub remote added"
fi

# Display pre-push information
echo ""
echo "======================================================================"
echo "  Ready to Push to GitHub"
echo "======================================================================"
echo ""
echo "Remote repository: $(git remote get-url origin)"
echo "Branch: main"
echo ""
echo -e "${YELLOW}IMPORTANT:${NC} You will need GitHub authentication"
echo ""
echo "GitHub will prompt for:"
echo "  Username: PremtimMorina"
echo "  Password: [Your Personal Access Token]"
echo ""
echo -e "${YELLOW}NOTE:${NC} Use Personal Access Token, NOT your GitHub password"
echo ""
echo "To create a token:"
echo "  1. Go to: https://github.com/settings/tokens"
echo "  2. Click 'Generate new token (classic)'"
echo "  3. Select 'repo' scope"
echo "  4. Copy the token and use as password"
echo ""
echo "Press Enter to continue with push, or Ctrl+C to cancel..."
read -r

# Push to GitHub
echo ""
echo "Pushing to GitHub..."
if git push -u origin main; then
    echo ""
    echo "======================================================================"
    echo -e "  ${GREEN}SUCCESS! Repository Uploaded to GitHub${NC}"
    echo "======================================================================"
    echo ""
    echo "Your repository is now live at:"
    echo "  https://github.com/PremtimMorina/kosovo-credit-market-research"
    echo ""
    echo "Next steps:"
    echo "  1. Visit repository URL to verify upload"
    echo "  2. Add repository topics/tags in Settings"
    echo "  3. Configure repository description"
    echo "  4. Enable GitHub Pages (optional)"
    echo ""
    echo "See GITHUB_UPLOAD_GUIDE.md for detailed instructions"
    echo ""
else
    echo ""
    echo "======================================================================"
    echo -e "  ${RED}PUSH FAILED${NC}"
    echo "======================================================================"
    echo ""
    echo "Common issues:"
    echo "  1. Authentication failed - Check Personal Access Token"
    echo "  2. Repository doesn't exist - Create on GitHub first"
    echo "  3. Network issues - Check internet connection"
    echo ""
    echo "See GITHUB_UPLOAD_GUIDE.md for troubleshooting"
    echo ""
    exit 1
fi
