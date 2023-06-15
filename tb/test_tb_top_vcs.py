

# This file contains a cocotb-pytest test.

# 1. Testbench 
#     - Any python function decorated with @cocotb.test()
#     - Drives signals into pins of the design, reads the output/intermediate pins and compares with expected results
#     - Uses async-await: 
#         - Declared as def async
#         - when "await Event()", simulator advances in simulation time until the Event() happens
#     - You can have multiple such testbenches.
# 2. Configuration is handled through def test_register(WIDTH_IN,WIDTH_OUT) function, at end of this file.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge, FallingEdge, ClockCycles

import random

import os
import sys
# sys.path.append(sys.path[0]+'/../ext/hw_blocks/tb')
# from fixed2mdlns import fixed2mdlns

import wavedrom
from cocotb.wavedrom import trace

from cocotb.binary import BinaryValue

@cocotb.test()
async def register_tb(dut):
    ''' # This test bench describes the register example.

        This Test bench operates register.sv 

        Describe it.
        
        The internal wires are:
        - 

        ![text about image](docs/register.svg)

        Reviewing the waves in these waveforms, clock, is a sampling clock, set to a rate of 2x clk.
        1. Reset is uncessary
        2. List the details about the waves
        3. What should happen at the edge
    '''
    
    # # Clock Generation 
    # clock = Clock(dut.clk, 10, units="ns") # create a clock for dut.clk pin with 10 ns period
    # cocotb.start_soon(clock.start()) # start clock in a seperate thread

    #sample clock generation
    sclock = Clock(dut.sample_clk, 2.5, units="ns") # create a clock for dut.sample_clk pin with 5 ns period
    cocotb.start_soon(sclock.start()) # start clock in a seperate thread

    # wavedrom trace, signals to be gathered from our DUT (Device Under Test)
    with cocotb.wavedrom.trace(
        dut.clk,
        dut.rst_n,
        #dut.cycle_cnt_q,
        dut.wrapper_i.instr_req, 
        dut.wrapper_i.instr_gnt,
        dut.wrapper_i.instr_rvalid,
        dut.wrapper_i.instr_addr,
        dut.wrapper_i.instr_rdata,
        dut.wrapper_i.data_req,
        clk=dut.sample_clk) as waves:

        # Example Test
        # Assign random values to input, wait for a clock and verify output 
        for i in range(10): # 10 experiments
            
            await FallingEdge(dut.clk) # wait for falling edge
            
            rst_n = dut.rst_n.value
            # computed = dut.q.value.signed_integer # Read pins as signed integer.
            print(rst_n)
            #assert exact == computed, f"Failed on the {i}th cycle. Got {computed}, expected {exact}" # If any assertion fails, the test fails, and the string would be printed in console
            #print(f"Driven value: {exact} \t received value: {computed}") 
        
        # Dump the wave traces
        j = waves.dumpj()
        # Print the Json wave trace to read it in terminal.
        print(j)
        # Render to svg.
        svg = wavedrom.render(j)
        svg.saveas("../../docs/register.svg")


# Pytest - Parametrized
from cocotb_test.simulator import run
import pytest
import glob
import platform

# Choose the simulator (vcs only choice)
simulator_choice = "vcs"
simulator_args=["-full64", "-sverilog", "+fw=pathToHex", "+lint=TFIPC-L", "+lint=PCWM", "-debug_access", "+plusarg_sav", "+firmware=pathToHex"]        
try:
    if "rhel" in platform.freedesktop_os_release()['ID']:
        simulator_choice = "vcs"
        # simulator_args=["-full64", "-sverilog", "+lint=TFIPC-L", "+lint=PCWM","-debug_access"]
except:
    print("Unable to access distro information")
    # simulator_choice = "icarus"
    # simulator_args = []

print("simulator choice",simulator_choice)

#Define test case parameter settings.
# Add any new parameters here with a new line.
# Then add the new parameter into the test_register arguments.

@pytest.mark.parametrize("INSTR_RDATA_WIDTH",[32])
@pytest.mark.parametrize("RAM_ADDR_WIDTH", [22])
@pytest.mark.parametrize("BOOT_ADDR",[384])
@pytest.mark.parametrize("PULP_XPULP", [0])
@pytest.mark.parametrize("PULP_CLUSTER", [0])
@pytest.mark.parametrize("FPU", [0])
# @pytest.mark.parametrize("FPU_ADDMUL_LAT", [0])
# @pytest.mark.parametrize("FPU_OTHERS_LAT", [0])
@pytest.mark.parametrize("ZFINX", [0])
@pytest.mark.parametrize("NUM_MHPMCOUNTERS", [1])
@pytest.mark.parametrize("DM_HALTADDRESS",[437323776])
def test_cv32e40p_top(INSTR_RDATA_WIDTH,RAM_ADDR_WIDTH,BOOT_ADDR,PULP_XPULP,PULP_CLUSTER,FPU,
#FPU_ADDMUL_LAT,FPU_OTHERS_LAT,
ZFINX,NUM_MHPMCOUNTERS,DM_HALTADDRESS):

    dut = 'tb_top' # Update the DUT to be the name of the module you want to test

    v_files = []
    with open(sys.path[0]+"/../tb_top.vfs") as f: # Change to the name of your repo created from ip_template
        myFile = f.read()
        v_files_pre = myFile.split(" ")
        for each in v_files_pre:
            v_files.append(each.replace("Designs/cv32e40p/","")) # Change ip_template


    local_d = dict(locals())
    parameters = {k: local_d[k] for k in local_d.keys() if k == k.upper()}
    print(parameters)
    
    run(
        python_search=['tb/'],
        verilog_sources=v_files,
        toplevel=dut,
        module=os.path.splitext(os.path.basename(__file__))[0],
        simulator=simulator_choice,
        verilog_compile_args = simulator_args,
        parameters=parameters,
        sim_build="sim_build/" + "_".join((f"{key}={value}" for key, value in parameters.items())),
        extra_env={f'PARAM_{k}': str(v) for k, v in parameters.items()},
    )
