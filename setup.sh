#!/usr/bin/env bash

# Setup Script: CachyOS & Hermes Agent (with Ollama)
# Highly optimized for Arch/CachyOS configurations

# Color formatting for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}===============================================${NC}"
echo -e "${BLUE}    CachyOS & Hermes Agent Installer Script    ${NC}"
echo -e "${BLUE}===============================================${NC}"

# 1. OS Verification
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "cachyos" && "$ID" != "arch" && "$ID_LIKE" != *"arch"* ]]; then
        echo -e "${RED}[!] Warning: This script is optimized for CachyOS/Arch Linux.${NC}"
        echo -e "${YELLOW}[?] You are running: $NAME. Proceed at your own risk. (y/N)${NC}"
        read -r proceed
        if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
            echo -e "${RED}[-] Installation cancelled.${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}[✓] Verified Arch-based/CachyOS distribution: $NAME${NC}"
    fi
else
    echo -e "${RED}[!] Could not detect OS version. Installation aborted.${NC}"
    exit 1
fi

# 2. Check for Sudo privileges
if ! command -v sudo &> /dev/null; then
    echo -e "${RED}[!] Sudo command not found. Please install sudo or run as root.${NC}"
    exit 1
fi

# Update repository databases
echo -e "${YELLOW}[*] Updating system package databases...${NC}"
sudo pacman -Syu --noconfirm

# 3. GPU Detection and Package Mapping
echo -e "${YELLOW}[*] Detecting Graphics Processing Unit (GPU)...${NC}"
GPU_TYPE="CPU"
OLLAMA_PKG="ollama"

# Run lspci to check for display/vga controllers
if lspci | grep -i "nvidia" &> /dev/null; then
    GPU_TYPE="NVIDIA"
    OLLAMA_PKG="ollama-cuda"
elif lspci | grep -i "advanced micro devices" &> /dev/null || lspci | grep -i "amd/ati" &> /dev/null; then
    GPU_TYPE="AMD"
    OLLAMA_PKG="ollama-rocm"
elif lspci | grep -i "intel" &> /dev/null; then
    GPU_TYPE="Intel"
    OLLAMA_PKG="ollama-vulkan"
fi

echo -e "${GREEN}[✓] Detected GPU type: ${GPU_TYPE}${NC}"
echo -e "${GREEN}[✓] Selected Ollama Package: ${OLLAMA_PKG}${NC}"

# 4. Install Dependencies & Ollama
echo -e "${YELLOW}[*] Installing dependencies and Ollama (${OLLAMA_PKG})...${NC}"
sudo pacman -S --needed --noconfirm base-devel git curl xz ripgrep ffmpeg $OLLAMA_PKG

# Add current user to video and render groups for GPU acceleration access
echo -e "${YELLOW}[*] Setting up hardware acceleration user permissions...${NC}"
sudo usermod -aG video,render "$USER"
echo -e "${GREEN}[✓] User added to 'video' and 'render' groups.${NC}"

# 5. Configure and Enable Ollama Service
echo -e "${YELLOW}[*] Configuring Ollama systemd service...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable --now ollama.service

echo -e "${GREEN}[✓] Ollama service started and enabled at boot.${NC}"

# 6. Install Hermes Agent
echo -e "${YELLOW}[*] Fetching and running Hermes Agent official installer...${NC}"
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash

# 7. Pull Default Model
echo -e "${YELLOW}[*] Pre-pulling recommended local LLM model (hermes3:8b)...${NC}"
echo -e "${YELLOW}This may take several minutes depending on your internet connection speed...${NC}"
ollama pull hermes3:8b

echo -e "${BLUE}===============================================${NC}"
echo -e "${GREEN}          Installation Complete!               ${NC}"
echo -e "${BLUE}===============================================${NC}"
echo -e "${YELLOW}Next Steps to run Hermes Agent:${NC}"
echo -e "1. ${BLUE}Restart your terminal session${NC} or run:"
echo -e "   ${GREEN}source ~/.bashrc${NC} (or ${GREEN}source ~/.zshrc${NC})"
echo -e "2. Configure Hermes Model Provider to point to local Ollama:"
echo -e "   ${GREEN}hermes model${NC} (Choose Custom/OpenAI-compatible, set URL to: http://localhost:11434/v1, model to: hermes3:8b)"
echo -e "3. Set longer timeouts for local inference response generation:"
echo -e "   ${GREEN}hermes config set HERMES_API_TIMEOUT 1800${NC}"
echo -e "4. Launch the interactive chat:"
echo -e "   ${GREEN}hermes chat${NC}"
echo -e "${BLUE}===============================================${NC}"
