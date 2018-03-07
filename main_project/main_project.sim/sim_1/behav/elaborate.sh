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
ExecStep $xv_path/bin/xelab -wto d11fd9260a384bc3a26442db9652b4b0 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip -L xpm --snapshot alu_tb_behav xil_defaultlib.alu_tb -log elaborate.log
