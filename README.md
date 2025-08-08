# tellingTime
A Linux Digital Clock Collection

This repository contains multiple implementations of digital clocks for Linux systems, including timezone support for all US time zones:

## Features

### C Implementation (`digital_clock.c`)
- **Large ASCII Art Display**: Shows time using large block characters
- **Colorful Interface**: Uses ANSI colors for visual appeal
- **12-hour Format**: Displays time in 12-hour format with AM/PM
- **Date Display**: Shows current date below the time
- **Real-time Updates**: Updates every second
- **Terminal-based**: Runs directly in the terminal

### Bash Script Implementation (`simple_clock.sh`)
- **Simple Clean Interface**: Minimalist design with borders
- **Color Coded**: Different colors for time, date, and messages
- **Lightweight**: Pure bash script with no external dependencies
- **Easy to Modify**: Simple shell script that's easy to customize

### Enhanced Smooth Clock (`smooth_clock.sh`)
- **No Flashing**: Smooth updates without screen clearing
- **Cursor Positioning**: Updates only time elements, not entire screen
- **Clean Design**: Elegant bordered display
- **Resource Efficient**: Minimal CPU usage

### Interactive Timezone Clock (`timezone_clock.sh`)
- **US Timezone Selection**: Switch between all major US timezones
- **Interactive Controls**: Press 'T' to change timezone, 'Q' to quit
- **Real-time Switching**: Instantly updates to selected timezone
- **Comprehensive Coverage**: Eastern, Central, Mountain, Pacific, Alaska, Hawaii, Arizona

### Multi-Zone Dashboard (`multizone_clock.sh`)
- **All Zones at Once**: Displays all US timezones simultaneously
- **Live Updates**: Shows real-time for all zones
- **Dashboard View**: Clean, organized multi-timezone display
- **Perfect for Coordination**: Great for scheduling across time zones

## Installation & Usage

### C Version

1. **Compile the clock:**
   ```bash
   make
   ```
   
   Or manually:
   ```bash
   gcc -Wall -Wextra -std=c99 -o digital_clock digital_clock.c
   ```

2. **Run the clock:**
   ```bash
   make run
   ```
   
   Or directly:
   ```bash
   ./digital_clock
   ```

3. **Optional: Install system-wide:**
   ```bash
   make install
   ```

### Bash Script Versions

#### Simple Clock
1. **Make executable (if not already):**
   ```bash
   chmod +x simple_clock.sh
   ```

2. **Run the clock:**
   ```bash
   ./simple_clock.sh
   ```

#### Smooth Clock (Recommended)
1. **Run the smooth, non-flashing clock:**
   ```bash
   ./smooth_clock.sh
   ```

#### Interactive Timezone Clock
1. **Run the timezone-enabled clock:**
   ```bash
   ./timezone_clock.sh
   ```
   
2. **Controls while running:**
   - Press `T` to open timezone selection menu
   - Choose 1-7 for different US timezones:
     - 1: Eastern Time (New York)
     - 2: Central Time (Chicago)
     - 3: Mountain Time (Denver)
     - 4: Pacific Time (Los Angeles)
     - 5: Alaska Time (Anchorage)
     - 6: Hawaii Time (Honolulu)
     - 7: Arizona Time (Phoenix)
   - Press `Q` to quit

#### Multi-Zone Dashboard
1. **Run the multi-timezone dashboard:**
   ```bash
   ./multizone_clock.sh
   ```

## Controls

- **Exit**: Press `Ctrl+C` to stop any clock
- **Timezone Clock**: Press `T` to change timezone, `Q` to quit
- **Multi-Zone**: Displays all timezones automatically

## Requirements

- Linux/Unix system with terminal support
- GCC compiler (for C version)
- Bash shell (for script version)
- Terminal with ANSI color support (most modern terminals)

## Makefile Commands

- `make` or `make all` - Compile the C program
- `make run` - Compile and run the clock
- `make clean` - Remove compiled files
- `make install` - Install to /usr/local/bin (requires sudo)
- `make uninstall` - Remove from system (requires sudo)

## Screenshots

The C version displays a large, colorful digital clock with:
- Large block digit display
- Colored time display (cyan digits, yellow colons)
- AM/PM indicator in green
- Full date in blue
- Decorative borders in magenta

The bash version shows:
- Clean bordered time display
- Color-coded elements
- Simple and elegant interface

The timezone versions offer:
- **Interactive Timezone Selection**: Switch between US timezones on demand
- **Multi-Zone Dashboard**: View all US timezones simultaneously
- **Real-time Updates**: All clocks update every second
- **No Flashing**: Smooth, professional display

Enjoy your new Linux digital clocks! 🕐
