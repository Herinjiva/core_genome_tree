'This script extracts the core genome sequences. Each fasta file contains homologous proteins. To be used after running make_core_genome.py (Jean-Noel Lorenzi)'

import os
import json
import argparse
from xmlrpc.client import boolean
from Bio import SeqIO

def get_args():
    """
    return parameters
    """

    parser = argparse.ArgumentParser()
    
    parser.add_argument("-core_list",
                        type= str,
                        required=True,
                        nargs='?',
                        help= "a dictionnary of the core genome from make_core_genome.py (.txt)")

    parser.add_argument("-taxa_name",
                        type=str,
                        required=True,
                        nargs='?',
                        help="name of the directory containing all species genomes. Used as output name")
    
    parser.add_argument("-homolog",
                        type= str,
                        required= True,
                        nargs= '?',
                        help= "dictionnary of homolog sequences from make_core_genome.py (.txt)")
    
    args = parser.parse_args()
    return args

def extract_gene(gene_id,input_file):
    fasta_sequences = SeqIO.parse(open(input_file),"fasta")
    for fasta in fasta_sequences:
        if fasta.id == gene_id:
            return fasta.id,str(fasta.seq)

def extract_homolog_sequences(fasta_directory,core_list,homolog):
    """
    For each gene, extract homolog sequences. one file => homolog genes
    """
    print("Extractig homolog...")
    output_f = fasta_directory + "_homolog"
    os.mkdir(output_f)
    with open(core_list,'r') as f_core, open(homolog,'r') as f_homolog:
        print("Loading json core...")
        core_dico = json.loads(f_core.read())
        print("Loading json homolog...")
        homolog_dico = json.loads(f_homolog.read())
    
    species1 = list(core_dico.keys())[0] #species1 will be used as reference for the homolog in other species
    gene_list_sp1 = core_dico[species1]
    species_list = list(homolog_dico[species1].keys())
    species_list.remove(species1)
    
    i = 0
    for gene1 in gene_list_sp1:
        i = i+1
        print("{}/{} gene".format(i,len(gene_list_sp1)), end="\r")
        with open(output_f + "/gene" + str(i) + ".fa","w") as gene_f:
            id,seq = extract_gene(gene1,fasta_directory + "/" + species1 + ".fa")
            gene_f.write(">" +id + "___" + species1 + "\n")
            gene_f.write(seq + "\n")

            for species2 in species_list:
                gene2 = homolog_dico[species1][species2][gene1]
                id,seq = extract_gene(gene2,fasta_directory + "/" + species2 + ".fa")
                gene_f.write(">" + id + "___" + species2 + "\n")
                gene_f.write(seq + "\n")
    print()

parameters = get_args()
core_list = parameters.core_list
fasta_dir = parameters.taxa_name
homolog = parameters.homolog

extract_homolog_sequences(fasta_dir, core_list, homolog)