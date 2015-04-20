SBT          ?= sbt
_SBT_FLAGS   ?= -Dsbt.log.noformat=true
SBT_FLAGS    ?=
DIR_SRC = src
DIR_BUILD = build

CHISEL_FLAGS :=

# EXECUTABLES = $(notdir $(basename $(wildcard $(DIR_SRC/*.scala))))
EXECUTABLES = TransactionTable
EMULATORS = $(EXECUTABLES:%=$(DIR_BUILD)/%.out)
HDLS = $(EXECUTABLES:%=$(DIR_BUILD)/%.v)

vpath %.scala $(DIR_SRC)

.PHONY: all emulator phony clean test verilog

default: all

$(DIR_BUILD)/%.out: %.scala
	set -e -o pipefail; \
	$(SBT) $(SBT_FLAGS) "run $(basename $(notdir $<)) --genHarness --compile --test --backend c --debug --vcd --targetDir $(DIR_BUILD)"

$(DIR_BUILD)/%.v: %.scala
	set -e -o pipefail; \
	$(SBT) $(SBT_FLAGS) "run $(basename $(notdir $<)) --genHarness --compile --backend v --targetDir $(DIR_BUILD)"

test: $(EMULATORS)

verilog: $(HDLS)

all: test

clean:
	rm $(DIR_BUILD)/*

# To build and run C++
#   run ProcessingElement --genHarness --compile --test --backend c --vcd
