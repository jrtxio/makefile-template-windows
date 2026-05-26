# makefile-template-windows

[English](README.md) | [中文](README.zh-CN.md)

A hierarchical multi-module Makefile template for **Windows** C and C++ projects, built with MinGW-w64 and Git-Bash.

The example project simulates a socket double linked list with create and release operations, demonstrating how to structure a multi-module build system.

## Features

- **Hierarchical build** — Each source module has its own sub-Makefile; the root Makefile orchestrates them
- **Centralized configuration** — All toolchain paths, flags, and directory settings live in `make_settings.mk`
- **Separate output directories** — Object files go to `Build/Obj/`, final executables to `Build/Gen/`
- **VS Code integration** — Pre-configured `launch.json` (GDB debug) and `tasks.json` (build/clean)
- **Portable paths** — Uses forward slashes throughout so the same Makefiles work under Git-Bash

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [MinGW-w64](https://www.mingw-w64.org/) | gcc 8.1.0+ | C/C++ compiler (`gcc.exe`, `gdb.exe`) |
| [Git for Windows](https://git-scm.com/) | Any | Provides Git-Bash shell for `make` |
| [Make](http://gnuwin32.sourceforge.net/packages/make.htm) | 3.82+ | Build automation (`make.exe`) |

## Quick Start

### 1. Clone the template

```bash
git clone https://github.com/jrtxio/makefile-template-windows.git my-project
cd my-project
```

### 2. Configure the toolchain

Edit `make_settings.mk` and set `INSTALL_DIR` to your MinGW installation path (default: `C:/Program Files/mingw64`):

```makefile
INSTALL_DIR ?= C:/Program Files/mingw64
```

### 3. Build

```bash
make all
```

### 4. Run

```bash
./Build/Gen/main.exe
```

### 5. Clean

```bash
make clean
```

## Make Targets

| Target | Description |
|--------|-------------|
| `all` | Create output dirs, compile all modules, link, and move the executable to `Build/Gen/` |
| `clean` | Remove all `.o` and `.exe` files from the build output directories |

## How to Customize

### Add a new source module

1. Create a new directory under `Source/`, e.g. `Source/mymodule/`
2. Add a `Makefile` inside it following the same pattern as `Source/main/Makefile`:

```makefile
CFILES = $(wildcard *.c)
OBJS   = $(CFILES:%.c=%.o)

all: $(OBJS)
%.o : %.c
	@echo $(<F)
	@$(subst \,/, $(CC) $(CFLAGS) -o $(OBJ_DIR)/$(@F) -c $<)
```

3. Register the module in `make_settings.mk`:

```makefile
APPL_SRC_DIRS = $(SRC_DIR)/main \
                $(SRC_DIR)/socket \
                $(SRC_DIR)/mymodule

APPL_INC_DIRS = $(SRC_DIR)/main \
                $(SRC_DIR)/socket \
                $(SRC_DIR)/mymodule
```

### Change the output binary name

In `make_settings.mk`, modify `IMAGE_SRC`:

```makefile
IMAGE_SRC = myapp
```

### Enable/disable debug symbols

In the root `Makefile`, set the `DEBUG` variable:

```makefile
DEBUG = 1   # enable -g flag
DEBUG = 0   # disable
```

## Project Structure

```
.
├── Makefile                  # Root Makefile — orchestrates build pipeline
├── make_settings.mk          # Centralized build configuration
├── .vscode/
│   ├── launch.json           # GDB debug configuration
│   ├── settings.json         # File associations & IntelliSense
│   └── tasks.json            # Build and clean tasks
├── Source/
│   ├── main/
│   │   ├── main.c            # Application entry point
│   │   └── Makefile           # Module Makefile
│   └── socket/
│       ├── fnet_socket.c/h   # Socket linked list implementation
│       ├── fnet_prot.c/h     # Protocol layer
│       ├── fnet_tcp.c/h      # TCP protocol handler
│       ├── fnet_socket_prv.h # Socket private definitions
│       ├── fnet_stack_config.h
│       ├── fnet_stdlib.h     # Standard library abstraction
│       └── Makefile           # Module Makefile
└── Build/                    # (generated) Build output
    ├── Obj/                  # Compiled object files
    └── Gen/                  # Final executable
```

## VS Code Integration

- **Build**: `Ctrl+Shift+B` runs `make all`
- **Clean**: Select the "clean" task from the task runner
- **Debug**: Press `F5` to build and debug with GDB (`stopAtEntry` enabled by default)
