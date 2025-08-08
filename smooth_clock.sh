#!/bin/bash

# Smooth Digital Clock in Bash (No Flashing)
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to move cursor to position
move_cursor() {
    printf "\033[%d;%dH" "$1" "$2"
}

# Function to hide cursor
hide_cursor() {
    printf "\033[?25l"
}

# Function to show cursor
show_cursor() {
    printf "\033[?25h"
}

# Function to clear screen once
clear_screen() {
    clear
}

# Function to initialize display
init_display() {
    clear_screen
    hide_cursor
    
    # Draw static elements that don't change
    move_cursor 2 25
    printf "${PURPLE}╔═══════════════════════════════════════╗${NC}"
    move_cursor 3 25
    printf "${PURPLE}║        SMOOTH DIGITAL CLOCK           ║${NC}"
    move_cursor 4 25
    printf "${PURPLE}╚═══════════════════════════════════════╝${NC}"
    
    # Draw time box frame
    move_cursor 7 20
    printf "${CYAN}╔══════════════════════════════╗${NC}"
    move_cursor 8 20
    printf "${CYAN}║                              ║${NC}"
    move_cursor 9 20
    printf "${CYAN}║                              ║${NC}"
    move_cursor 10 20
    printf "${CYAN}╚══════════════════════════════╝${NC}"
    
    # Draw instructions
    move_cursor 15 22
    printf "${RED}Press Ctrl+C to exit this clock${NC}"
}

# Function to update only the time (no flashing)
update_time() {
    local current_time=$(date '+%I:%M:%S %p')
    local current_date=$(date '+%A, %B %d, %Y')
    
    # Update time in the box (overwrite previous time)
    move_cursor 9 22
    printf "${YELLOW}%-28s${NC}" "$current_time"
    
    # Update date below
    move_cursor 12 15
    printf "${GREEN}%-40s${NC}" "$current_date"
}

# Function to cleanup on exit
cleanup() {
    show_cursor
    move_cursor 17 1
    printf "${GREEN}Clock stopped. Terminal restored.${NC}\n"
    exit 0
}

# Trap Ctrl+C to cleanup properly
trap cleanup INT

# Initialize the display
echo "Starting Smooth Digital Clock..."
echo "Initializing display..."
sleep 1

init_display

# Main loop - only update the time, not the whole screen
while true; do
    update_time
    sleep 1
done
