'This script builds build a multisequence from a core gene'

from distutils import extension
import os
import argparse
from xmlrpc.client import boolean
from Bio import SeqIO

def get_args():
    """
    return parameters
    """
    parser = argparse.ArgumentParser()
    
    parser.add_argument("-input",
                        type= str,
                        required=True,
                        nargs='?',
                        help= "folder containing fasta file")

    parser.add_argument("-extension",
                        type=str,
                        default= ".afa",
                        nargs='?',
                        help=" fasta file to be considered (default afa for alignement)")
    
    parser.add_argument("-output",
                        type= str,
                        required= True,
                        nargs= '?',
                        help= "outfile name")
    args = parser.parse_args()
    return args
    
def build_dico(fasta_file):
    ss_dico = {}
    fasta_file = SeqIO.parse(open(fasta_file),"fasta")

    for fasta in fasta_file:
        ss_dico[str(fasta.id).split("___")[1]] = ""

    return ss_dico

def build_Sup_Seq(input, output,extension):
    file_list = os.listdir(input)
    ss_dico = build_dico(input+"/"+file_list[1]) ##order of sequences will be based on sequences inside species1

    for file in file_list:
        fasta_file = SeqIO.parse(open(input+"/"+file),"fasta")
        print(file)
        for fasta in fasta_file:
            species = str(fasta.id).split("___")[1]
            ss_dico[species] = ss_dico[species] + str(fasta.seq)
    
    with open(output + ".afa", "w") as output_f:
        for id, seq in ss_dico.items():
            output_f.write(">" + id + "\n" + seq + "\n")

parameters = get_args()
input = parameters.input
output = parameters.output
ext = parameters.extension

build_Sup_Seq(input, output, ext)
