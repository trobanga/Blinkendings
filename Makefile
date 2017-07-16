project = blinkendings
family = "Cyclone V"
device = 5CGXFC5C6F27C7
src = src/blinkendings.vhdl src/ws2812/ws2812.vhdl src/uart/uart.vhd src/uart/comp/uart_rx.vhd src/uart/comp/uart_tx.vhd src/uart/comp/uart_parity.vhd src/conways_game_of_life.vhdl
assignment = $(project).qsf
output_files = output_files
sdc_file = blinkendings.sdc


map_args = --read_settings_files=on --write_settings_files=off $(foreach s, $(src), --source=$(s)) -p
fit_args = --read_settings_files=off --write_settings_files=off -p
asm_args = --read_settings_files=off --write_settings_files=off
eda_args = --read_settings_files=off --write_settings_files=off
gen_tb_args = --read_settings_files=on --write_settings_files=off 
sta_slow_args =  --model=slow
sta_fast_args =  --model=fast


# stamp the chg file so subsequent executables will be run
stamp = echo done >

smart.log: $(assignment)
	quartus_sh --determine_smart_action $(project) > smart.log


create_project:
	quartus_sh -t setup_proj.tcl -project $(project) -family $(family) -device $(device) -output_files $(output_files) -sdc_file $(sdc_file)
	quartus_sh -t pin_assignments.tcl -project $(project)

all: spinal_hdl map fit asm sta summary



# spinalHDL

SCALA_MAIN = Blinkendings
SCALA_SRCS = $(wildcard src/scala/*.scala)
SCALA_BUILDDIR = build
SCALA_SCALA = scala-2.11
SCALA_COMPILER = scalac-2.11
CLASSPATH = ./$(SCALA_BUILDDIR)/scala:./lib/spinalhdl-core.jar:./lib/spinalhdl-lib.jar:./lib/scopt.jar

compile_scala:
	@mkdir -p $(BUILDDIR)/scala/
	$(SCALA_COMPILER) -cp "$(CLASSPATH)" -d $(BUILDDIR)/scala $(SCALA_SRCS)

spinal_hdl: compile_scala
	$(SCALA_SCALA)  -cp "$(CLASSPATH)" $(SCALA_MAIN)
	mv *.vhd src

# mapping
map: smart.log $(project).map.rpt
$(project).map.rpt: map.chg
	quartus_map $(map_args) $(project)
	$(stamp) fit.chg
	@cat $(output_files)/$(project).map.summary

# fitting
fit: smart.log $(project).fit.rpt
$(project).fit.rpt: fit.chg
	quartus_fit $(fit_args) $(project)
	$(stamp) asm.chg
	$(stamp) sta.chg
	@cat $(output_files)/$(project).fit.summary

# output binary
asm: smart.log $(project).asm.rpt
$(project).asm.rpt: asm.chg
	quartus_asm $(asm_args) $(project)


# netlist for simulation
eda: smart.log $(project).eda.rpt
$(project).eda.rpt:
	quartus_eda $(eda_args) $(project)

gen_test_bench:
	quartus_eda $(gen_tb_args) $(project) -c $(project) --gen_testbench

simulate:
	vsim -do sim.tcl


# timing reports
sta: smart.log $(project).sta.rpt
timing: smart.log $(project).sta.rpt

$(project).sta.rpt: $(project).sta_slow.rpt $(project).sta_fast.rpt

$(project).sta_slow.rpt: sta.chg
	quartus_sta $(sta_slow_args) $(project)
	@mv $(output_files)/$(project).sta.rpt $(output_files)/$(project).sta_slow.rpt
	@mv $(output_files)/$(project).sta.summary $(output_files)/$(project).sta_slow.summary

$(project).sta_fast.rpt: sta.chg
	quartus_sta $(sta_fast_args) $(project)
	@mv $(output_files)/$(project).sta.rpt $(output_files)/$(project).sta_fast.rpt
	@mv $(output_files)/$(project).sta.summary $(output_files)/$(project).sta_fast.summary

check_io:
	quartus_fit --check_ios $(project)

prog:
	quartus_pgm --mode=JTAG -o "p;$(output_files)/$(project).sof"


summary:
	@echo
	@cat $(output_files)/$(project).map.summary
	@echo
	@cat $(output_files)/$(project).fit.summary
	@echo
	@cat $(output_files)/$(project).sta_slow.summary
	@echo
	@cat $(output_files)/$(project).sta_fast.summary
