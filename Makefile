#Directories
VERILOGDIR ?= verilog
VERILOGPATH = /home/pro/masters/ntabatab/a-core_thesydekick/Entities/qspi_master/chisel/verilog
SCALAPATH = /home/pro/masters/ntabatab/a-core_thesydekick/Entities/qspi_master/chisel/src/main/scala
#DEPDIR :=.depdir
#$(shell mkdir -p $(DEPDIR) >/dev/null)
$(shell mkdir -p $(VERILOGPATH) >/dev/null)
MODULES= 
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

qspi_master: $(VERILOGDIR)/qspi_master.v
$(VERILOGDIR)/qspi_master.v:
	$(SBT) 'runMain qspi_master.qspi_master $(MAINPARAMS)'

clean:
	rm -f $(VERILOGPATH)/*.v
	rm -f $(VERILOGPATH)/*.sv
	rm -f $(VERILOGPATH)/*.anno
	rm -f $(VERILOGPATH)/*.fir

#Generate cleanup recipes for individual modules


help:
	@echo "configured modules are:";
	@for i in $(MODULES) ; do \
	   echo $$i; \
	done
