# core_genome_tree
This repository contains four scripts to generate the core genome and build a tree from it.

It contains 4 steps :
1. Blast all vs all
2. make core genome
3. alignement and trimming (using muscle and trimAl)
4. build the core genome tree (Using IQ-tree)

** NB : BLAST, alignement and phylogeneic inference are computationaly demanding with huge datastes like the core-genome. We suggest running them on a cluster to speed up the calcualtion **

# Blast all vs all
**Requirement** : BLAST (Altschul SF, Gish W, Miller W, Myers EW, Lipman DJ. Basic local alignment search tool)
To install blast on your machine follow this link [install blast](https://www.ncbi.nlm.nih.gov/books/NBK569861/).
Once you have installed BLAST :
- first, create the BLAST db for every species.
Put all the protein files (format fasta) for each species inside a directory called "prot" (one fasta file for one species). 
Therefore, run the script blast_db_creation.sh (modify the permission if necessary)
```
./blast_db_creation.sh
```
The database is stored in Blast_db

- Next, run all the blast (all vs all) with launch_blast.sh. Do not hesitate to modify number of threads depending on your computer facilities. BLAST result will be stored in Blast_output
```
./launch_blast.sh
```

# make core genome
**Requirement** : make_core_genome.py (Jean-Noël Lorenzi)
Once you have your blast result, run the above python script to determine the core genome of all your species.
```
python make_core_genome **blast_output** **run_name** **core_output**
```

This script will generate two .json files: 
- core_run_name.txt : the list of core genome for each species in dictionnary format (key : species ID, value : list of protein belonging to the core)
- hommolog_run_name.txt : dictionnary of homologs for each proteins of each species in other species.

At this step, you only have the list of the core genome. In order to construct a fasta file of the core, use the python script core_extract.py. This script will put holomologous protein which constitute the core genome in a fasta file. The number of fasta file created is the size of the core genome.
```
python core_extract.py -core_list core_run_name.txt -homolog hommolog_run_name.txt -taxa_name prot/
```

# alignement and trimming
**Requirements** : MUSCLE (Edgar, R.C. MUSCLE: a multiple sequence alignment method with reduced time and space complexity) and trimAl (Salvador Capella-Gutiérrez, José M. Silla-Martínez, Toni Gabaldón, trimAl: a tool for automated alignment trimming in large-scale phylogenetic analyses)

# build the core genome tree
