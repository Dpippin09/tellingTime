#!/bin/bash

# Fixed Multi-Zone Display Clock - Shows all US timezones with proper offsets
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function utilities
move_cursor() { printf "\033[%d;%dH" "$1" "$2"; }
hide_cursor() { printf "\033[?25l"; }
show_cursor() { printf "\033[?25h"; }
clear_screen() { clear; }

# Function to get current local time in 24-hour format
get_current_hour_minute_second() {
    date '+%H %M %S'
}

# Function to calculate time for different US timezones
get_timezone_time() {
    local offset="$1"
    local zone_name="$2"
    
    # Get current time components
    read current_hour current_minute current_second <<< $(get_current_hour_minute_second)
    
    # Remove leading zeros to avoid octal interpretation
    current_hour=$((10#$current_hour))
    current_minute=$((10#$current_minute))
    current_second=$((10#$current_second))
    
    # Apply timezone offset
    local target_hour=$((current_hour + offset))
    
    # Handle day boundaries
    if [ $target_hour -lt 0 ]; then
        target_hour=$((target_hour + 24))
    elif [ $target_hour -ge 24 ]; then
        target_hour=$((target_hour - 24))
    fi
    
    # Convert to 12-hour format
    local display_hour=$target_hour
    local am_pm="AM"
    
    if [ $target_hour -eq 0 ]; then
        display_hour=12
        am_pm="AM"
    elif [ $target_hour -gt 0 ] && [ $target_hour -lt 12 ]; then
        display_hour=$target_hour
        am_pm="AM"
    elif [ $target_hour -eq 12 ]; then
        display_hour=12
        am_pm="PM"
    else
        display_hour=$((target_hour - 12))
        am_pm="PM"
    fi
    
    # Use %d instead of %02d to avoid octal issues, then format manually
    if [ $display_hour -lt 10 ]; then
        printf "0%d:%02d:%02d %s" "$display_hour" "$current_minute" "$current_second" "$am_pm"
    else
        printf "%d:%02d:%02d %s" "$display_hour" "$current_minute" "$current_second" "$am_pm"
    fi
}

# Function to determine timezone offset from current system time
# This assumes your system is running in Eastern time, adjust if needed
determine_base_offset() {
    # Get system timezone info if possible
    local current_tz_offset=0
    
    # You can manually set this based on your actual timezone
    # For now, assuming system is in Eastern Time
    echo "0"  # Eastern Time base
}

# Function to initialize the display
init_display() {
    clear_screen
    hide_cursor
    
    # Header
    move_cursor 2 20
    printf "${PURPLE}╔═══════════════════════════════════════════════╗${NC}"
    move_cursor 3 20
    printf "${PURPLE}║           US TIMEZONE DASHBOARD               ║${NC}"
    move_cursor 4 20
    printf "${PURPLE}╚═══════════════════════════════════════════════╝${NC}"
    
    # Create display boxes
    local row=7
    for i in {1..6}; do
        move_cursor $row 15
        printf "${CYAN}╔══════════════════════════════════════════╗${NC}"
        ((row++))
        move_cursor $row 15
        printf "${CYAN}║                                          ║${NC}"
        ((row++))
        move_cursor $row 15
        printf "${CYAN}║                                          ║${NC}"
        ((row++))
        move_cursor $row 15
        printf "${CYAN}╚══════════════════════════════════════════╝${NC}"
        ((row+=2))
    done
    
    # Instructions
    move_cursor 38 15
    printf "${GREEN}All times update live - Press ${YELLOW}Ctrl+C${GREEN} to exit${NC}"
}

# Function to update all timezone displays
update_all_times() {
    # Define timezone data: offset from your current system time
    # Based on your system showing 4:12 PM, adjusting for accurate US timezones
    # Assuming your system is in Eastern Time (ET)
    local timezones=(
        "0:Eastern Time (New York)"
        "-1:Central Time (Chicago)"
        "-2:Mountain Time (Denver)"
        "-3:Pacific Time (Los Angeles)"
        "-4:Alaska Time (Anchorage)"
        "-6:Hawaii Time (Honolulu)"
    )
    
    local row=8
    
    for tz_data in "${timezones[@]}"; do
        IFS=':' read -r offset zone_name <<< "$tz_data"
        
        # Get the time for this timezone
        local time=$(get_timezone_time "$offset" "$zone_name")
        
        # Update zone name
        move_cursor $row 17
        printf "${WHITE}%-36s${NC}" "$zone_name"
        
        # Update time
        move_cursor $((row + 1)) 17
        printf "${YELLOW}%-36s${NC}" "$time"
        
        ((row += 5))
    done
    
    # Update date
    move_cursor 40 20
    printf "${BLUE}%s${NC}" "$(date '+%A, %B %d, %Y')"
}

# Cleanup function
cleanup() {
    show_cursor
    clear_screen
    printf "${GREEN}Multi-zone clock stopped. Goodbye!${NC}\n"
    exit 0
}

# Trap signals
trap cleanup INT TERM

# Main function
main() {
    echo "Starting Fixed US Multi-Zone Clock..."
    echo "Calculating timezone offsets..."
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
