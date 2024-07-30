MAKEFLAGS += -rR
MAKEFLAGS += --no-print-directory

export CONFLIST  := conf
export ASSETLIST := asset

export BASHRC := $(HOME)/.bashrc

# fst stands for fast (non-interactive)
fst_setups := $(notdir $(wildcard scripts/setup-*.sh))

# itr stands for interactive
itr_setups += $(patsubst itr-%,%,$(notdir $(wildcard scripts/itr-setup-*.sh)))

.PHONY: $(fst_setups) $(itr_setups)

all: $(fst_setups)

$(fst_setups):
	@bash scripts/libsetup.sh scripts/$@

$(itr_setups):
	@bash scripts/libsetup.sh scripts/itr-$@
