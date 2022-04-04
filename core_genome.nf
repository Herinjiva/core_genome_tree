proteins = Channel.fromPath( 'prot/*.fa' )

process blast_db_creation {
  input:
  file query_file from proteins

  """
  cd /mnt/c/Users/herin/Desktop/temp/core_genome_tree
  touch ${query_file} 
  """

}