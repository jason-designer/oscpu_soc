OSCPU_HOME = $(shell pwd)
BUILD_PATH = $(OSCPU_HOME)/projects/chisel_cpu_diff/build/


	TEST_FILE = inst_diff.bin
ifdef ALL4
	TEST_FILE = non-output/cpu-tests/$(ALL4)-cpu-tests.bin
endif
ifdef ALL3
	TEST_FILE = non-output/riscv-tests/$(ALL3)-riscv-tests.bin
endif
ifdef ALL
	TEST_FILE = $(ALL)
endif

sim:
	./build.sh -e chisel_cpu_diff -d -b -s -a "-i $(TEST_FILE) --wave-path=wave.vcd --dump-wave -b 0" -m "EMU_TRACE=1" -b

simnowave:
	./build.sh -e chisel_cpu_diff -d -b -s -a "-i $(TEST_FILE) -b 0" -m "EMU_TRACE=1" -b

simall:
	./build.sh -e chisel_cpu_diff -b -r "non-output/cpu-tests non-output/riscv-tests"

wave:
	gtkwave $(BUILD_PATH)/wave.vcd

.PHONY: sim wave simall



