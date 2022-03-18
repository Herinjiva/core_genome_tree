#!/bin/bash

####PARAMETERS####
working_directory=${wd:-.}
bl_output=${blast_output}
run_name=${run_name}
core_output=${core_output}
#####END PARAMETERS####

cd $working_directory

echo "$bl_output"
echo "$run_name"
echo "$core_output"

python3 make_core_genome.py $bl_output $run_name $core_output
python3 core_extract.py -core_list "${core_output}core_${run_name}.txt" -homolog "${core_output}homolog_${run_name}.txt" -taxa_name prot
