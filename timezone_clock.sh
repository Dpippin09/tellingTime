#!/bin/bash

# Multi-Timezone Digital Clock for United States
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# US Timezone mappings
declare -A TIMEZONES=(
    ["1"]="America/New_York:Eastern (ET)"
    ["2"]="America/Chicago:Central (CT)" 
    ["3"]="America/Denver:Mountain (MT)"
    ["4"]="America/Los_Angeles:Pacific (PT)"
    ["5"]="America/Anchorage:Alaska (AKT)"
    ["6"]="Pacific/Honolulu:Hawaii (HST)"
    ["7"]="America/Phoenix:Arizona (MST)"
)

# Current timezone (default to Eastern)
CURRENT_TZ="America/New_York"
CURRENT_TZ_NAME="Eastern (ET)"

# Function to move cursor to position
move_cursor() {
    printf "\033[%d;%dH" "$1" "$2"
}

# Function to hide/show cursor
hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }
clear_screen() { clear; }

# Function to display timezone menu
show_timezone_menu() {
    move_cursor 16 15
    printf "${WHITE}╔══════════════════════════════════════════════╗${NC}"
    move_cursor 17 15
    printf "${WHITE}║              TIMEZONE SELECTOR               ║${NC}"
    move_cursor 18 15
    printf "${WHITE}╠══════════════════════════════════════════════╣${NC}"
    move_cursor 19 15
    printf "${WHITE}║ ${CYAN}1${NC} - Eastern Time  (New York)     ${YELLOW}[ET]${NC}   ${WHITE}║${NC}"
    move_cursor 20 15
    printf "${WHITE}║ ${CYAN}2${NC} - Central Time  (Chicago)     ${YELLOW}[CT]${NC}   ${WHITE}║${NC}"
    move_cursor 21 15
    printf "${WHITE}║ ${CYAN}3${NC} - Mountain Time (Denver)      ${YELLOW}[MT]${NC}   ${WHITE}║${NC}"
    move_cursor 22 15
    printf "${WHITE}║ ${CYAN}4${NC} - Pacific Time  (Los Angeles) ${YELLOW}[PT]${NC}   ${WHITE}║${NC}"
    move_cursor 23 15
    printf "${WHITE}║ ${CYAN}5${NC} - Alaska Time   (Anchorage)   ${YELLOW}[AKT]${NC}  ${WHITE}║${NC}"
    move_cursor 24 15
    printf "${WHITE}║ ${CYAN}6${NC} - Hawaii Time   (Honolulu)    ${YELLOW}[HST]${NC}  ${WHITE}║${NC}"
    move_cursor 25 15
    printf "${WHITE}║ ${CYAN}7${NC} - Arizona Time  (Phoenix)     ${YELLOW}[MST]${NC}  ${WHITE}║${NC}"
    move_cursor 26 15
    printf "${WHITE}╠══════════════════════════════════════════════╣${NC}"
    move_cursor 27 15
    printf "${WHITE}║ ${RED}C${NC} - Cancel and return to clock           ${WHITE}║${NC}"
    move_cursor 28 15
    printf "${WHITE}╚══════════════════════════════════════════════╝${NC}"
    move_cursor 30 15
    printf "${GREEN}Enter your choice (1-7 or C): ${NC}"
}

# Function to clear the menu area
clear_menu() {
    for i in {16..31}; do
        move_cursor $i 15
        printf "%-50s" ""
    done
}

# Function to initialize display
init_display() {
    clear_screen
    hide_cursor
    
    # Draw header
    move_cursor 2 20
    printf "${PURPLE}╔════════════════════════════════════════════╗${NC}"
    move_cursor 3 20
    printf "${PURPLE}║        US MULTI-TIMEZONE CLOCK             ║${NC}"
    move_cursor 4 20
    printf "${PURPLE}╚════════════════════════════════════════════╝${NC}"
    
    # Draw time box frame
    move_cursor 7 18
    printf "${CYAN}╔══════════════════════════════════════╗${NC}"
    move_cursor 8 18
    printf "${CYAN}║                                      ║${NC}"
    move_cursor 9 18
    printf "${CYAN}║                                      ║${NC}"
    move_cursor 10 18
    printf "${CYAN}╚══════════════════════════════════════╝${NC}"
    
    # Draw timezone indicator box
    move_cursor 12 22
    printf "${WHITE}╔══════════════════════════════╗${NC}"
    move_cursor 13 22
    printf "${WHITE}║                              ║${NC}"
    move_cursor 14 22
    printf "${WHITE}╚══════════════════════════════╝${NC}"
    
    # Draw instructions
    move_cursor 32 10
    printf "${GREEN}Controls: ${YELLOW}[T]${NC} = Change Timezone  ${YELLOW}[Q]${NC} = Quit  ${YELLOW}[Ctrl+C]${NC} = Exit"
}

# Function to update time display
update_time() {
    # Get time in selected timezone
    local current_time=$(TZ="$CURRENT_TZ" date '+%I:%M:%S %p')
    local current_date=$(TZ="$CURRENT_TZ" date '+%A, %B %d, %Y')
    
    # Update time in the box
    move_cursor 9 20
    printf "${YELLOW}%-34s${NC}" "$current_time"
    
    # Update timezone indicator
    move_cursor 13 24
    printf "${GREEN}%-26s${NC}" "Timezone: $CURRENT_TZ_NAME"
    
    # Update date below
    move_cursor 16 15
    printf "${BLUE}%-40s${NC}" "$current_date"
}

# Function to handle timezone change
change_timezone() {
    show_timezone_menu
    
    # Read user input with timeout
    read -t 30 -n 1 choice
    
    case $choice in
        [1-7])
            if [[ -n "${TIMEZONES[$choice]}" ]]; then
                IFS=':' read -r tz_code tz_name <<< "${TIMEZONES[$choice]}"
                CURRENT_TZ="$tz_code"
                CURRENT_TZ_NAME="$tz_name"
                clear_menu
                move_cursor 30 15
                printf "${GREEN}Timezone changed to: $tz_name${NC}"
                sleep 1
                clear_menu
            fi
            ;;
        [Cc])
            clear_menu
            ;;
        *)
            clear_menu
            move_cursor 30 15
            printf "${RED}Invalid choice! Press any key to continue...${NC}"
            read -t 2 -n 1
            clear_menu
            ;;
    esac
}

# Function to handle user input in background
handle_input() {
    while true; do
        read -s -n 1 key
        case $key in
            [Tt])
                change_timezone
                ;;
            [Qq])
                cleanup
                ;;
        esac
    done
}

# Function to cleanup on exit
cleanup() {
    show_cursor
    clear_screen
    printf "${GREEN}Multi-timezone clock stopped. Goodbye!${NC}\n"
    exit 0
}

# Trap Ctrl+C and Q to cleanup properly
trap cleanup INT TERM

# Main function
main() {
    echo "Starting US Multi-Timezone Digital Clock..."
    echo "Loading..."
    sleep 2
    
    init_display
    
    # Start input handler in background
    handle_input &
    INPUT_PID=$!
    
    # Main clock loop
    while true; do
        update_time
        sleep 1
    done
}

# Start the application
main
