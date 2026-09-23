#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

workflow {
   println "\nSAMTOOLS IDXSTATS\n"
   bam = getbams()
   indexedbam = indexbam(bam).view()
   getIdxstats(indexedbam).view()
}

def getbams() {
  return \
    channel
      .fromFilePairs( params.bam_dir + "*.{bam,cram}", size: 1 )
      .map { name, bam -> tuple(name, bam.first()) }
}

process indexbam() {
  tag "processing ${bam.baseName}"
  label 'samtools'
  publishDir \
    path: "${params.bam_dir}",
    mode: 'copy'
  input:
    tuple \
      val(bamName), \
      path(bam)
  output:
    tuple \
      val(bamName), \
      path(bam), \
      path("*.{bai,crai}")
  script:
    """
    samtools \
      index \
      -@ ${task.cpus} \
      ${bam}
    """
}

process getIdxstats() {
  tag "processing ${name}"
  label 'samtools'
  publishDir \
    path: "${params.bam_dir}",
    mode: 'copy'
  input:
    tuple \
      val(name), \
      path(bam), \
      path(index)
  output:
    tuple \
      val(name), \
      path(bam), \
      path(index), \
      path("${name}.idxstats")
  script:
    """
    samtools \
      idxstats \
      --threads ${task.cpus} \
      ${bam} \
      > ${name}.idxstats
    """
}
