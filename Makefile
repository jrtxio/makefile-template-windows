#============================================================================
#               C O P Y R I G H T
#-----------------------------------------------------------------------------
# Copyright (c) by JRTx-Tech Technology Co. Ltd.    All rights reserved.
#
#    This software is furnished under a license and may be used and copied
# only in accordance with the terms of such license and with the inclusion
# of the above copyright notice. This software or any other copies thereof
# may not be provided or otherwise made available to any other person.
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
#	Project:        Socket Double Linked List
#	Compiler:       gcc version 8.1.0
#	Shell:	        Git-Bash
#
#	Author:         Ji Ren
#	Creation Date:  2022-04-12
#----------------------------------------------------------------------------
# Description:
#		This is the main makefile for all makefiles
#
#============================================================================

include make_settings.mk

RM = rm -f

#----------------------------------------------------------------------------
# application specific settings
OBJ_DIR = $(SRC_OBJ_DIR)
MODULES = $(APPL_SRC_DIRS)
IMAGE = $(IMAGE_SRC)

DEBUG = 1
RUNTIME = 0

ifeq ($(strip $(DEBUG)),1)
X86_CFLAGS += -g
endif

X86_CFLAGS += $(addprefix -I, $(APPL_INC_DIRS))
CFLAGS = $(strip $(X86_CFLAGS))

X86_LDFLAGS += $(strip $(OBJ_FILES))
LDFLAGS = $(strip $(X86_LDFLAGS))

#----------------------------------------------------------------------------
# export variables to sub-makefiles
export OBJ_DIR
export CFLAGS
export CC
export MAKE

OBJ_FILES = $(wildcard $(OBJ_DIR)/*.o)

#----------------------------------------------------------------------------
.PHONY: all clean clr

all: checkDirs compile link cpy
clean: clr

#----------------------------------------------------------------------------
# check directories: if Obj or Gen doesn't exist create it
checkDirs:
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(GEN_DIR)

#----------------------------------------------------------------------------
# clear output files
clr:
	$(RM) $(OBJ_DIR)/*.o
	$(RM) $(GEN_DIR)/*.exe

#----------------------------------------------------------------------------
# call all sub-makefiles
compile:
	for dir in $(MODULES); do \
	$(MAKE) -C $$dir -s ; \
	done

#----------------------------------------------------------------------------
link: $(OBJ_DIR)/$(IMAGE).exe
$(OBJ_DIR)/$(IMAGE).exe:
	@echo "============================================================"
	@echo "            > link $(@F) <                                  "
	@echo "============================================================"
	$(CC) $(LDFLAGS) -o $(OBJ_DIR)/$(IMAGE).exe

#----------------------------------------------------------------------------
# copy .exe from Obj to Gen
cpy:
	@mv $(OBJ_DIR)/$(IMAGE).exe $(GEN_DIR)/$(IMAGE).exe
