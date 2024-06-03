ROOT := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BRUTIL := $(ROOT)/brutil
TARGET := $(shell cat $(ROOT)/Makefile.target)

export ROOT BRUTIL

RUN := bash

.PHONY: $(TARGET)

$(TARGET):
	bash $(ROOT)/$@
