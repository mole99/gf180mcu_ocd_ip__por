#!/bin/bash
#
# Run LEF generation on the 3.3V PoR
#
echo ${PDK_ROOT:=/usr/share/pdk} > /dev/null
echo ${PDK:=gf180mcuD} > /dev/null
project=gf180mcu_ocd_ip__por

echo "Running GDS and LEF generation on ${project}"
magic -dnull -noconsole -rcfile ${PDK_ROOT}/${PDK}/libs.tech/magic/${PDK}.magicrc << EOF

gds readonly true
gds rescale false

gds read ../gds/${project}.gds.gz

load ${project}
select top cell
port vdd3v3 class inout
port vdd3v3 use  power
port vss class inout
port vss use ground
port ena class input
port ena use signal
port por class output
port por use signal
port porb class output
port porb use signal
port por_unbuf class output
port por_unbuf use signal
lef write -hide
quit -noprompt
EOF
rm -rf extfiles
mv ${project}.lef ../lef/
echo "Done"
