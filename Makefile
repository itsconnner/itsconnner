ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BRUTIL := $(ROOT)/brutil

export ROOT BRUTIL

RUN := bash

all: alias coredump filemap keymap onedrive terminal

alias:
	$(RUN) $(ROOT)/$@

coredump:
	$(RUN) $(ROOT)/$@

filemap:
	$(RUN) $(ROOT)/$@

keymap:
	$(RUN) $(ROOT)/$@

onedrive:
	$(RUN) $(ROOT)/$@

terminal:
	$(RUN) $(ROOT)/$@ $(M)

.PHONY: all alias coredump filemap keymap onedrive terminal
