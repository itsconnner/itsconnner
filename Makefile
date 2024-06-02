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

onedrive:
	$(RUN) $(ROOT)/$@

.PHONY: alias coredump filemap keymap onedrive
