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
ExecStep $xv_path/bin/xelab -wto d11fd9260a384bc3a26442db9652b4b0 -m64 --debug typical --relax --mt 8 -L blk_mem_gen_v8_3_5 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot datapath_behav xil_defaultlib.datapath xil_defaultlib.glbl -log elaborate.log
