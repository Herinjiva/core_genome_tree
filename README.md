# core_genome_tree
This repository contains four scripts to generate the core genome and build a tree from it.

It contains 4 steps :
1. Blast all vs all
2. make core genome
3. alignement and trimming (using muscle and trimAl)
4. build the core genome tree (Using IQ-tree)

**NB : BLAST, alignement and phylogeneic inference are computationaly demanding with huge datasets like the core-genome. We suggest running them on a cluster to speed up the calcualtion**  

## Blast all vs all
**Requirement** : BLAST (Altschul SF, Gish W, Miller W, Myers EW, Lipman DJ. Basic local alignment search tool)  
To install blast on your machine follow this link [install blast](https://www.ncbi.nlm.nih.gov/books/NBK569861/).  
Once you have installed BLAST :
- first, create the BLAST db for every species.
Put all the protein files (format fasta) for each species inside a directory called **"prot"** (one fasta file for one species). 
Therefore, run the script blast_db_creation.sh (modify the permission if necessary).  
Locally : 
```
./blast_db_creation.sh
```   
If you are working on PBS cluster:
```
qsub -v blast_bin="absolute/path/makebalstdb",wd="absolute/path/core_gennome_tree" blast_db_creation.sh
```
Or you can manually modified blast_bin and working_directory variable.  
  
The database is stored in Blast_db
  
- Next, run all the blast (all vs all) with launch_blast.sh. Do not hesitate to modify number of threads depending on your computer facilities. BLAST results will be stored in Blast_output.
Locally : 
```
./launch_blast.sh
```   
If you are working on PBS cluster:
```
qsub -v blast_bin="absolute/path/blastp",wd="absolute/path/core_gennome_tree" blast_db_creation.sh
```
Or you can manually modified blast_bin and working_directory variable.  

## make core genome
**Requirements** : make_core_genome.py (Jean-Noël Lorenzi), core_extract.py
Once you have your blast result, run the first above python script to determine the core genome of all your species.In order to construct a fasta file of the core, use the python script core_extract.py. This script will put holomologous protein,which constitute the core genome, in a fasta file. The number of fasta file created is the size of the core genome.
Locally:  
```
python make_core_genome;py **blast_output_directory** **run_name** **core_output_directory**
python core_extract.py -core_list core_output_directory/core_run_name.txt -homolog -homolog_run_name.txt -taxa_name prot/
```
  
If you are working on PBS cluster, use the core_genome_wrapper.py:
```
qsub -v wd="absolute/path/core_genome_tree",blast_output="Blast_output/",run_name="run_name",core_output="core_output_name" make_core_genome_wrapper.sh
```

output: taxa_name_homolog  

## Multiple sequence alignement.
**Requirements** : MUSCLE (Edgar, R.C. MUSCLE: a multiple sequence alignment method with reduced time and space complexity)
To launch the phylogenetic inference tool, we need an alignement of each homologous group. We use MUSCLE to perform this task.
muscle.sh will align sequences inside every homologous group.
```
./muscle.sh
```
output: run_name_homolog_msa.afa  
After the MSA, we build a supersequence for each species
```
python builSuperSeq.py -input run_name_homolog_msa.afa -output output_name
```

## build the core genome tree
For the the phylognentic inference, we chose IQ-tree( L.-T. Nguyen, H.A. Schmidt, A. von Haeseler, and B.Q. Minh (2015) IQ-TREE: A fast and effective stochastic algorithm for estimating maximum likelihood phylogenies), the successor of IQPNNI and TREE-PUZZLE software.  
To install IQtree use this link : [install IQTREE](http://www.iqtree.org/doc/Quickstart#installation)
```
iqtree -s msa_outputname_ss.afa -nt AUTO -ntmax AUTO
```

## ALL at once
If you want phylogenetic inference directly by using the core genome, use the core_genome_tree.sh script. But, be sure you have BLAST, MUSCLE and IQTREE installed.
If you work on a cluster, add the working directory ad the beginning of the script and instead of calling BLAST,MUSCLE and IQTREE directly, use absolute path.
