# Makefile for Digital Clock
CC=gcc
CFLAGS=-Wall -Wextra -std=c99
TARGET=digital_clock
SOURCE=digital_clock.c

# Default target
all: $(TARGET)

# Compile the digital clock
$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) -o $(TARGET) $(SOURCE)

# Clean up compiled files
clean:
	rm -f $(TARGET)

# Install the clock (optional)
install: $(TARGET)
	sudo cp $(TARGET) /usr/local/bin/

# Uninstall the clock (optional)
uninstall:
	sudo rm -f /usr/local/bin/$(TARGET)

# Run the clock
run: $(TARGET)
	./$(TARGET)

.PHONY: all clean install uninstall run
