#!/bin/bash

# Simple Digital Clock in Bash
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to clear screen
clear_screen() {
    clear
}

# Function to display clock
display_simple_clock() {
    while true; do
        clear_screen
        
        # Get current time and date
        current_time=$(date '+%I:%M:%S %p')
        current_date=$(date '+%A, %B %d, %Y')
        
        # Display header
        echo -e "${PURPLE}╔════════════════════════════════════╗${NC}"
        echo -e "${PURPLE}║          SIMPLE BASH CLOCK         ║${NC}"
        echo -e "${PURPLE}╚════════════════════════════════════╝${NC}"
        echo ""
        
        # Display time in large format
        echo -e "        ${CYAN}╔══════════════════════╗${NC}"
        echo -e "        ${CYAN}║                      ║${NC}"
        echo -e "        ${CYAN}║   ${YELLOW}$current_time${CYAN}   ║${NC}"
        echo -e "        ${CYAN}║                      ║${NC}"
        echo -e "        ${CYAN}╚══════════════════════╝${NC}"
        echo ""
        
        # Display date
        echo -e "        ${GREEN}$current_date${NC}"
        echo ""
        echo -e "        ${RED}Press Ctrl+C to exit${NC}"
        
        # Wait 1 second before updating
        sleep 1
    done
}

# Trap Ctrl+C to exit gracefully
trap 'echo -e "\n\n${GREEN}Clock stopped. Goodbye!${NC}"; exit 0' INT

# Start the clock
echo "Starting Simple Bash Clock..."
sleep 1
display_simple_clock
