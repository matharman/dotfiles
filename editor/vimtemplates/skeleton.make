# Compiler and Linker
CC          := gcc

# The Target Binary Program
TARGET      := program

# The Directories, Source, Includes, Objects, Binary and Resources
SRCDIR      := src
INCDIR      := inc
RESDIR      := etc
OBJDIR      := obj
TARGETDIR   := bin

# Flags, Libraries and Includes
CFLAGS      := -Wall -Wextra -Wpedantic -Werror -g
LIB         := 
INC         := -I$(INCDIR)

SRC         := $(shell find $(SRCDIR) -type f -name *.c)
OBJ         := $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(SRC:.c=.o))

# Default Make
all: $(TARGET)

# Remake
remake: cleaner all

# Copy Resources from Resources Directory to Target Directory
resources: directories
	@cp $(RESDIR)/* $(TARGETDIR)/

# Make the Directories
directories:
	@mkdir -p $(TARGETDIR)
	@mkdir -p $(OBJDIR)

# Clean only Objecst
clean:
	@rm -rf $(OBJDIR)

# Full Clean, Objects and Binaries
cleaner: clean
	@rm -rf $(TARGETDIR)

# Link
$(TARGET): $(OBJ)
	$(CC) -o $(TARGETDIR)/$(TARGET) $^ $(LIB)

# Compile
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $< $(INC)

# Non-File Targets
.PHONY: all remake clean cleaner resources
