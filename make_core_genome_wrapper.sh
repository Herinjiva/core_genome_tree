#!/bin/bash

####PARAMETERS####
working_directory=${wd:-.}
bl_output=${blast_output}
run_name=${run_name}
core_output=${core_output}
#####END PARAMETERS####

cd $working_directory

python3 make_core_genome.py $bl_output $run_name $core_output
