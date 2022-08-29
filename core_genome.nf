//PARAMETERS
params.workdir = "."
params.makeblastdb_bin = "makeblastdb"
params.blastp_bin = "blastp"
params.run = "user"

//PATH
path_core_output = "./core_output/"
path_to_db="./Blast_db/"
path_to_prot_file="./prot/"
path_to_blast_out="./Blast_output/"

//CHANNEL
proteins_ch = Channel.fromPath(path_to_prot_file + "*.fa")
query_ch = Channel.fromPath(path_to_prot_file + "*.fa")

println params.workdir
file(params.workdir+"/"+"Blast_output").mkdirs()
file(params.workdir+"/"+"Blast_db").mkdirs()
file(params.workdir+"/"+"Homolog").mkdirs()

process blast_db_creation {

  input:
  file query_file from proteins_ch

  output:
  file query_file into db_ch

  shell:
  '''
  cd !{params.workdir}
  species="!{query_file}"
  !{params.makeblastdb_bin} -in !{path_to_prot_file}$species -dbtype "prot" -out !{path_to_db}${species%.fa}
  '''
}

process launch_blast {

  input:
  file target from db_ch.flatten()
  each query from query_ch

  output:
  stdout result

  when:
  target.getName().equals(query.name) == false //if the query and target is different

  """
  #!/usr/bin/env bash

  cd $params.workdir
  sp_query="$query.baseName"
  sp_target="$target"

  out=\${sp_query}-vs-\${sp_target%.fa}.bl
  $params.blastp_bin -query $path_to_prot_file\${sp_query}.fa -db $path_to_db\${sp_target%.fa} -num_threads 2 -outfmt '7 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen gaps' > $path_to_blast_out\${out}
  """
}

process make_core_genome {
  input:
  val go from result.collect() //force to wait launch_blast to finish

  output:
  stdout result_core
 """
  #!/usr/bin/env bash

  cd $params.workdir
  
  python3 make_core_genome.py $path_to_blast_out $params.run $path_core_output
  """
}

process extract_core {

  input:
  val go from result_core.collect()

  output:
  stdout extract_result

  """
  #!/usr/bin/env bash
  cd $params.workdir
  core_json="$path_core_output"
  core_json+="core_"
  core_json+="$params.run"
  core_json+=".txt"
  homolog_json="$path_core_output"
  homolog_json+="homolog_"
  homolog_json+="$params.run"
  homolog_json+=".txt"
  python3 core_extract.py -core_list \${core_json} -homolog \${homolog_json} -taxa_name $path_to_prot_file
  """
}


process enumerate_homolog {

  input:
  val go from extract_result

  output:
  file '*.fa' into homolog_ch

  script:
  """
  cd $params.workdir
  cp Homolog/*fa \${PWD}
  """
}
