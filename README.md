# core_genome_tree
This repository contains four scripts to generate the core genome and build a tree from it.

It contains 4 steps :
1. Blast all vs all
2. make core genome
3. alignement and trimming
4. build the core genome tree

# Blast all vs all
**Requirements** : BLAST (Altschul SF, Gish W, Miller W, Myers EW, Lipman DJ. Basic local alignment search tool. J Mol Biol. 1990 Oct 5;215(3):403-10. doi: 10.1016/S0022-2836(05)80360-2. PMID: 2231712.)
To install blast on your machine follow this link [install blast](https://www.ncbi.nlm.nih.gov/books/NBK569861/).
Once you have installed BLAST :
- first, create the BLAST db for every species.
Put all the protein file (format fasta) for each species inside a directory called "prot" (one fasta file for one species). 
Therefore, run the script blast_db_creation.sh (modify the permission if necessary)
```
./blast_db_creation.sh
```
The database is stored in Blast_db

- Next, run all the blast (all vs all) with launch_blast.sh. Do not hesitate to modify the output format or nb of threads depending on your computer facilities
```
./launch_blast.sh
```
# make core genome


# alignement and trimming


# build the core genome tree
