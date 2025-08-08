#!/bin/bash

# Multi-Zone Display Clock - Shows all US timezones at once
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to move cursor and display utilities
move_cursor() { printf "\033[%d;%dH" "$1" "$2"; }
hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }
clear_screen() { clear; }

# Function to get time for a specific timezone using offset calculation
get_timezone_time() {
    local offset="$1"
    local zone_name="$2"
    
    # Get current UTC time in seconds since epoch
    local utc_seconds=$(date -u '+%s')
    
    # Add the offset (in hours converted to seconds)
    local zone_seconds=$((utc_seconds + offset * 3600))
    
    # Format the time for the timezone
    if command -v date >/dev/null 2>&1; then
        # Try different date command formats
        if date -d "@$zone_seconds" '+%I:%M:%S %p' 2>/dev/null; then
            return
        elif date -r "$zone_seconds" '+%I:%M:%S %p' 2>/dev/null; then
            return
        else
            # Fallback: manual calculation
            get_manual_time "$offset"
        fi
    else
        get_manual_time "$offset"
    fi
}

# Manual time calculation fallback
get_manual_time() {
    local offset="$1"
    
    # Get local time components
    local hour=$(date '+%H')
    local minute=$(date '+%M')
    local second=$(date '+%S')
    
    # Calculate offset from local time (assuming local is Eastern for this example)
    # You may need to adjust this based on your actual local timezone
    local adjusted_hour=$((hour + offset + 3))  # +3 assumes local is EST relative to PST base
    
    # Handle day rollover
    if [ $adjusted_hour -lt 0 ]; then
        adjusted_hour=$((adjusted_hour + 24))
    elif [ $adjusted_hour -ge 24 ]; then
        adjusted_hour=$((adjusted_hour - 24))
    fi
    
    # Convert to 12-hour format
    local display_hour=$adjusted_hour
    local am_pm="AM"
    
    if [ $adjusted_hour -eq 0 ]; then
        display_hour=12
    elif [ $adjusted_hour -gt 12 ]; then
        display_hour=$((adjusted_hour - 12))
        am_pm="PM"
    elif [ $adjusted_hour -eq 12 ]; then
        am_pm="PM"
    fi
    
    printf "%02d:%s:%s %s" "$display_hour" "$minute" "$second" "$am_pm"
}

# Function to initialize the multi-zone display
init_display() {
    clear_screen
    hide_cursor
    
    # Main header
    move_cursor 2 25
    printf "${PURPLE}╔═══════════════════════════════════════════════╗${NC}"
    move_cursor 3 25
    printf "${PURPLE}║           US TIMEZONE DASHBOARD               ║${NC}"
    move_cursor 4 25
    printf "${PURPLE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Create boxes for each timezone
    local row=7
    local zones=("Eastern" "Central" "Mountain" "Pacific" "Alaska" "Hawaii")
    
    for zone in "${zones[@]}"; do
        # Zone header
        move_cursor $row 20
        printf "${CYAN}╔════════════════════════════════╗${NC}"
        ((row++))
        move_cursor $row 20
        printf "${CYAN}║ ${WHITE}%-14s${CYAN}                 ║${NC}" "$zone Time"
        ((row++))
        move_cursor $row 20
        printf "${CYAN}║                                ║${NC}"
        ((row++))
        move_cursor $row 20
        printf "${CYAN}╚════════════════════════════════╝${NC}"
        ((row+=2))
    done
    
    # Instructions
    move_cursor 32 20
    printf "${GREEN}Live updating every second - Press ${YELLOW}Ctrl+C${GREEN} to exit${NC}"
    
    # Current date
    move_cursor 34 20
    printf "${BLUE}%s${NC}" "$(date '+%A, %B %d, %Y')"
}

# Function to update all timezone displays
update_all_times() {
    # US Timezone offsets from Eastern Time (EST/EDT)
    # Note: These are standard offsets, may need DST adjustments
    local timezone_offsets=(
        "0"    # Eastern (reference)
        "-1"   # Central (1 hour behind Eastern)
        "-2"   # Mountain (2 hours behind Eastern)
        "-3"   # Pacific (3 hours behind Eastern) 
        "-4"   # Alaska (4 hours behind Eastern)
        "-5"   # Hawaii (5 hours behind Eastern, no DST)
    )
    
    local zone_names=(
        "Eastern (ET)"
        "Central (CT)"
        "Mountain (MT)"
        "Pacific (PT)"
        "Alaska (AKT)"
        "Hawaii (HST)"
    )
    
    local row=9
    
    for i in "${!timezone_offsets[@]}"; do
        local time=$(get_timezone_time "${timezone_offsets[$i]}" "${zone_names[$i]}")
        
        # Update time display
        move_cursor $row 22
        printf "${YELLOW}%-28s${NC}" "$time"
        
        # Update timezone label
        move_cursor $((row-1)) 22
        printf "${WHITE}%-14s${CYAN}                 " "${zone_names[$i]%% *}"
        
        ((row+=5))
    done
    
    # Update date
    move_cursor 34 20
    printf "${BLUE}%-40s${NC}" "$(date '+%A, %B %d, %Y')"
}

# Cleanup function
cleanup() {
    show_cursor
    clear_screen
    printf "${GREEN}Multi-zone clock stopped. Terminal restored.${NC}\n"
    exit 0
}

# Trap signals
trap cleanup INT TERM

# Main execution
main() {
    echo "Starting US Multi-Zone Dashboard Clock..."
    echo "Loading timezone data..."
    sleep 2
    
    init_display
    
    # Main update loop
    while true; do
        update_all_times
        sleep 1
    done
}

# Start the clock
main
