#============================================================================
#                              C O P Y R I G H T
#-----------------------------------------------------------------------------
#    Copyright (c) by JRTx-Tech Technology Co. Ltd. All rights reserved.
#
#    This software is furnished under a license and may be used and copied
#    only in accordance with the terms of such license and with the inclusion
#    of the above copyright notice. This software or any other copies thereof
#    may not be provided or otherwise made available to any other person.
#    No title to and ownership of the software is hereby transferred.
#
#    The information in this software is subject to change without notice
#    and should not be construed as a commitment by
#    JRTx-Tech Technology Co. Ltd.
#
#    JRTx-Tech Technology Co. Ltd assumes no responsibility for the use
#    or reliability of its Software on equipment which is not supported by
#    JRTx-Tech Technology Co. Ltd.
#----------------------------------------------------------------------------
#    Project:        Socket Double Linked List
#    Compiler:       gcc version 8.1.0
#    Shell:          Git-Bash
#
#    Author:         Ji Ren
#    Creation Date:  2022-04-12
#----------------------------------------------------------------------------
# Description:
#        This is the setting for make environment
#
#============================================================================

# Project root (auto-detected, or override via: make PROJECT_DIR=/your/path)
PROJECT_DIR ?= $(CURDIR)

# Compiler directory — override to match your MinGW installation
INSTALL_DIR ?= C:/Program Files/mingw64

#----------------------------------------------------------------------------
#  Setup the Make Environment
#----------------------------------------------------------------------------

TOOL_DIR = $(INSTALL_DIR)/bin
SRC_OBJ_DIR = $(PROJECT_DIR)/Build/Obj
SRC_DIR = $(PROJECT_DIR)/Source

# Assembler
AS = $(INSTALL_DIR)/bin/as.exe

# C Compiler
CC = $(INSTALL_DIR)/bin/gcc.exe

MAKE = make

#----------------------------------------------------------------------------
#  Setup the directories used during the build
#----------------------------------------------------------------------------

# list of all directories where Source files could be found
APPL_SRC_DIRS = $(SRC_DIR)/main \
                $(SRC_DIR)/socket

# list of all directories where Header files could be found
APPL_INC_DIRS = $(SRC_DIR)/main \
                $(SRC_DIR)/socket

# All object files will be copied to the OBJ_DIR
OBJ_DIR = $(PROJECT_DIR)/Build/Obj

# Files generated during Build Process
GEN_DIR = $(PROJECT_DIR)/Build/Gen

#----------------------------------------------------------------------------
#  Setup the filenames and lists of files used during the build
#----------------------------------------------------------------------------

# Name of the image to be created
IMAGE_SRC = main

#----------------------------------------------------------------------------
#  Setup the flags of preprocessor, compiler and linker
#----------------------------------------------------------------------------

# CFLAGS: Flags of C-Compiler
X86_CFLAGS = -mthreads
X86_CFLAGS += -fforce-addr

# ---- End of make settings ----
