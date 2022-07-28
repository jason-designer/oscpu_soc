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

verilog:
	cd $(OSCPU_HOME)/projects/chisel_cpu_diff; \
	mkdir vsrc 1>/dev/null 2>&1; \
	mill -i oscpu.runMain TopMain -td vsrc

sim:
	./build.sh -e chisel_cpu_diff -d -b -s -a "-i $(TEST_FILE) --wave-path=wave.vcd --dump-wave -b 0" -m "EMU_TRACE=1" -b

simnowave:
	./build.sh -e chisel_cpu_diff -d -b -s -a "-i $(TEST_FILE) -b 0" -m "EMU_TRACE=1" -b

simall:
	./build.sh -e chisel_cpu_diff -b -r "non-output/cpu-tests non-output/riscv-tests"

simtestall:
	make simall
	make simnowave ALL=non-output/microbench/microbench-test.bin
	make simnowave ALL=custom-output/hello/amtest-hello.bin
	make simnowave ALL=custom-output/time-test/amtest-time-test.bin
	make simnowave ALL=custom-output/benchmark/microbench/microbench-test.bin
	make simnowave ALL=custom-output/yield-test/amtest-yield-test.bin
	make simnowave ALL=custom-output/interrupt-test/amtest-interrupt-test.bin
	make simnowave ALL=custom-output/rt-thread/rtthread.bin

wave:
	gtkwave $(BUILD_PATH)/wave.vcd

########################### SoC #############################################
SOC_TEST_FILE = ysyxSoC/$(ALL)

verilogsoc:
	make verilog
	cp projects/chisel_cpu_diff/vsrc/SimTop.v projects/soc/vsrc/ysyx_210888.v
	perl -p -i -e "s/ysyx_210888_SimTop/ysyx_210888/g" projects/soc/vsrc/ysyx_210888.v

simsoc:
	./build.sh -e soc -b -s -y -v '--timescale "1ns/1ns" -Wno-fatal --trace' -a "-i $(SOC_TEST_FILE) --dump-wave"

wavesoc:
	gtkwave projects/soc/build_test/vlt_dump.vcd

.PHONY: sim wave simall verilog



