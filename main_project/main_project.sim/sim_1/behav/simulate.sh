#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim controller_fsm_behav -key {Behavioral:sim_1:Functional:controller_fsm} -tclbatch controller_fsm.tcl -log simulate.log
