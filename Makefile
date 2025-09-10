#Directories
VERILOGDIR ?= verilog
VERILOGPATH = /home/pro/prinsys/onuman/tsmc_prinsys_work/tsmcN65-chip/coderP/source/coderP/verilog
SCALAPATH = /home/pro/prinsys/onuman/tsmc_prinsys_work/tsmcN65-chip/coderP/source/coderP/src/main/scala
#DEPDIR :=.depdir
#$(shell mkdir -p $(DEPDIR) >/dev/null)
$(shell mkdir -p $(VERILOGPATH) >/dev/null)
MODULES= AXI4LQSPI
TEST_MODULES=
PACKAGE=qspi_master

TARGETS = $(foreach name,$(MODULES), $(VERILOGDIR)/$(name).v)
TEST_TARGETS = $(foreach name,$(TEST_MODULES), test_$(name))

#Commands
SBT=sbt -J-Xmx16G -J-Xss8M

# Default parameters

td ?= "$(VERILOGDIR)"


MAINPARAMS = -td $(td)

TOUCH=touch -r
vpath %.scala $(SCALAPATH)/qspi_master
vpath %.scala $(SCALAPATH)/clockgen
vpath %.scala $(SCALAPATH)/rx
vpath %.scala $(SCALAPATH)/tx
.PHONY: all help clean $(MODULES)


all: qspi_master

AXI4LQSPI:
	$(SBT) 'runMain qspi_master.AXI4LQSPI -td verilog'

qspi_master: $(VERILOGDIR)/qspi_master.v
$(VERILOGDIR)/qspi_master.v:
	$(SBT) 'runMain qspi_master.qspi_master $(MAINPARAMS)'

clean:
	rm -f $(VERILOGPATH)/*.v
	rm -f $(VERILOGPATH)/*.sv
	rm -f $(VERILOGPATH)/*.anno
	rm -f $(VERILOGPATH)/*.fir

#Generate cleanup recipes for individual modules
.PHONY: clean_AXI4LQSPI
clean_AXI4LQSPI:
	rm -f $(VERILOGPATH)/AXI4LQSPI.v
	rm -f $(VERILOGPATH)/AXI4LQSPI.anno
	rm -f $(VERILOGPATH)/AXI4LQSPI.fir
	rm -f $(VERILOGPATH)/AXI4LQSPI_memmapped.conf
	rm -f $(VERILOGPATH)/AXI4LQSPI_memmapped.v

help:
	@echo "configured modules are:";
	@for i in $(MODULES) ; do \
	   echo $$i; \
	done
