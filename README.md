# makefile-template-windows

A multi-module Makefile template for Windows C and C++ projects (MinGW + Git-Bash).

The example project simulates a socket double linked list with create/release operations.

## Features

- Hierarchical multi-module build (sub-directory Makefiles)
- Centralized build settings (`make_settings.mk`)
- Separate Obj/Gen output directories
- VS Code build/debug tasks included

## Prerequisites

- [MinGW-w64](https://www.mingw-w64.org/) (gcc 8.1.0+)
- [Git for Windows](https://git-scm.com/) (provides Git-Bash)

## Usage

```bash
# Configure: edit INSTALL_DIR in make_settings.mk if needed
# (defaults to C:/Program Files/mingw64)

# Build
make all

# Clean
make clean

# Run
./Build/Gen/main.exe
```

## Project Structure

```
.
├── Makefile              # Main build entry
├── make_settings.mk      # Build configuration (paths, flags)
├── Source/
│   ├── main/             # Application entry
│   └── socket/           # Socket linked list module
└── Build/                # Build output (generated)
    ├── Obj/              # Object files
    └── Gen/              # Final executable
```
