#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>

// ANSI color codes for styling
#define RESET_COLOR "\033[0m"
#define CYAN "\033[36m"
#define YELLOW "\033[33m"
#define GREEN "\033[32m"
#define BLUE "\033[34m"
#define MAGENTA "\033[35m"
#define RED "\033[31m"

// Function to clear the terminal screen
void clear_screen() {
    system("clear");
}

// Function to move cursor to a specific position
void move_cursor(int row, int col) {
    printf("\033[%d;%dH", row, col);
}

// Function to display large ASCII digits for the time
void print_large_digit(int digit, int row, int col) {
    const char* digits[10][5] = {
        // 0
        {"█████", "█   █", "█   █", "█   █", "█████"},
        // 1
        {"  █  ", " ██  ", "  █  ", "  █  ", "█████"},
        // 2
        {"█████", "    █", "█████", "█    ", "█████"},
        // 3
        {"█████", "    █", "█████", "    █", "█████"},
        // 4
        {"█   █", "█   █", "█████", "    █", "    █"},
        // 5
        {"█████", "█    ", "█████", "    █", "█████"},
        // 6
        {"█████", "█    ", "█████", "█   █", "█████"},
        // 7
        {"█████", "    █", "   █ ", "  █  ", " █   "},
        // 8
        {"█████", "█   █", "█████", "█   █", "█████"},
        // 9
        {"█████", "█   █", "█████", "    █", "█████"}
    };
    
    for (int i = 0; i < 5; i++) {
        move_cursor(row + i, col);
        printf("%s%s%s", CYAN, digits[digit][i], RESET_COLOR);
    }
}

// Function to print colon separator
void print_colon(int row, int col) {
    move_cursor(row + 1, col);
    printf("%s█%s", YELLOW, RESET_COLOR);
    move_cursor(row + 3, col);
    printf("%s█%s", YELLOW, RESET_COLOR);
}

// Function to display the digital clock
void display_clock() {
    time_t raw_time;
    struct tm *time_info;
    
    // Get current time
    time(&raw_time);
    time_info = localtime(&raw_time);
    
    int hours = time_info->tm_hour;
    int minutes = time_info->tm_min;
    int seconds = time_info->tm_sec;
    
    // Convert to 12-hour format
    int display_hours = hours;
    char am_pm[3] = "AM";
    if (hours >= 12) {
        strcpy(am_pm, "PM");
        if (hours > 12) {
            display_hours = hours - 12;
        }
    }
    if (display_hours == 0) {
        display_hours = 12;
    }
    
    // Clear screen and position cursor
    clear_screen();
    
    // Display title
    move_cursor(2, 25);
    printf("%s╔═══════════════════════════════════════╗%s", MAGENTA, RESET_COLOR);
    move_cursor(3, 25);
    printf("%s║           DIGITAL CLOCK               ║%s", MAGENTA, RESET_COLOR);
    move_cursor(4, 25);
    printf("%s╚═══════════════════════════════════════╝%s", MAGENTA, RESET_COLOR);
    
    // Calculate positions for centering the clock
    int start_row = 8;
    int start_col = 15;
    
    // Display hours
    print_large_digit(display_hours / 10, start_row, start_col);
    print_large_digit(display_hours % 10, start_row, start_col + 7);
    
    // Display first colon
    print_colon(start_row, start_col + 15);
    
    // Display minutes
    print_large_digit(minutes / 10, start_row, start_col + 18);
    print_large_digit(minutes % 10, start_row, start_col + 25);
    
    // Display second colon
    print_colon(start_row, start_col + 33);
    
    // Display seconds
    print_large_digit(seconds / 10, start_row, start_col + 36);
    print_large_digit(seconds % 10, start_row, start_col + 43);
    
    // Display AM/PM
    move_cursor(start_row + 6, start_col + 20);
    printf("%s%s%s", GREEN, am_pm, RESET_COLOR);
    
    // Display date
    char date_str[100];
    strftime(date_str, sizeof(date_str), "%A, %B %d, %Y", time_info);
    move_cursor(start_row + 8, start_col + 10);
    printf("%s%s%s", BLUE, date_str, RESET_COLOR);
    
    // Display instructions
    move_cursor(start_row + 12, start_col + 8);
    printf("%sPress Ctrl+C to exit%s", RED, RESET_COLOR);
    
    fflush(stdout);
}

int main() {
    printf("Starting Digital Clock...\n");
    printf("Press Ctrl+C to exit\n");
    sleep(2);
    
    // Main clock loop
    while (1) {
        display_clock();
        sleep(1);  // Update every second
    }
    
    return 0;
}
