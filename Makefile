ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BRUTIL := $(ROOT)/brutil

export ROOT BRUTIL

RUN := bash

alias:
	$(RUN) $(ROOT)/$@

coredump:
	$(RUN) $(ROOT)/$@

filemap:
	$(RUN) $(ROOT)/$@

keymap:
	$(RUN) $(ROOT)/$@

all: alias coredump filemap keymap

.PHONY: all alias coredump filemap keymap
