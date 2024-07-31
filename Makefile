# SPDX-License-Identifier: GPL-3.0-only

MAKEFLAGS += -rR
MAKEFLAGS += --no-print-directory

export CONFLIST  := conf
export ASSETLIST := asset

export ABSROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export ABSGEN  := $(ABSROOT)/generated

export BASHRC  := $(HOME)/.bashrc
export PROFILE := $(HOME)/.profile

# fst stands for fast (non-interactive)
fst_setups := $(notdir $(wildcard scripts/setup-*.sh))

# itr stands for interactive
itr_setups += $(patsubst itr-%,%,$(notdir $(wildcard scripts/itr-setup-*.sh)))

.PHONY: $(fst_setups) $(itr_setups) fast-conf all

fast-conf: $(fst_setups)

all: $(fst_setups) $(itr_setups)

$(fst_setups):
	@bash scripts/libsetup.sh scripts/$@

$(itr_setups):
	@bash scripts/libsetup.sh scripts/itr-$@
