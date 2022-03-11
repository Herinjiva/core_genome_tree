#! /bin/bash

./blast_db_creation.sh
./launch_blast.sh
python3 make_core_genome;py **blast_output** **run_name** **core_output**
python3 core_extract.py -core_list core_run_name.txt -homolog hommolog_run_name.txt -taxa_name prot/
./muscle.sh
python3 builSuperSeq.py -input run_name_homolog_msa.afa -output output_name
iqtree -s msa_outputname_ss.afa -nt AUTO -ntmax AUTO
