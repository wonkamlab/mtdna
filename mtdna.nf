#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

workflow {
  println "\nMitoHPC\n"
  getBamDir().view()
  init = getInit().view()
  mitohpc(init).view()
}

params.init = "${projectDir}/init.sh"

def getBamDir() {
  return \
    channel
      .fromPath(
        params.bam_dir,
        type: 'dir'
      )
      .flatten()
}

def getinit() {
  return channel.fromPath( params.init )
}

process getInit() {
  tag "running..."
  label 'mitohpc'
  //publishDir \
  //    path: "${params.output_dir}",
  //    mode: 'copy'
  output:
    tuple \
      path("in.txt"), \
      path("run.all.sh")
  script:
    """
    . ${projectDir}/includes/init.sh \
      ${params.ref} \
      ${params.bam_dir} \
      ${task.cpus} \
      ${task.memory.toGiga()}G \
      ${params.output_dir}

    chmod 755 run.all.sh

    ./run.all.sh
    """
}

process mitohpc() {
  tag "running..."
  label 'mitohpc'
  publishDir \
    path: "${params.output_dir}",
    mode: 'copy'
  input:
    tuple \
      path(infile), \
      path(runfile)
  output:
    path("*")
  script:
    """
    chmod 755 run.all.sh
    #sed -i "s|/filter|filter|g" run.all.sh
    ./run.all.sh 
    """
}

