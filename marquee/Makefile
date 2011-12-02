# Your Arduino environment.
ARD_REV = 22
ARD_HOME = /Applications/Arduino.app/Contents/Resources/Java
AVR_HOME = $(ARD_HOME)/hardware/tools/avr
ARD_BIN = $(AVR_HOME)/bin
AVRDUDE = $(ARD_BIN)/avrdude
AVRDUDE_CONF = $(AVR_HOME)/etc/avrdude.conf

# Your favorite serial monitor.
MON_CMD = echo
MON_SPEED = 9600

# Board settings.
BOARD = uno
PORT = /dev/tty.usbmodem1d11
PROGRAMMER = stk500v1

# Where to find header files and libraries.
INC_DIRS = ./inc
LIB_DIRS = $(addprefix $(ARD_HOME)/libraries/, $(LIBS))
LIBS = LiquidCrystal

include ../Makefile.master

namecard.pde: marquee.h

test: test.cpp
	cc -o $@ $^
	./test
