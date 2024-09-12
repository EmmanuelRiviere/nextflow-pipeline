process SAMTOOLS_SAM_TO_BAM {
    tag "${sampleID}"
    publishDir "${params.outName}/BWA", mode: params.publishDirMode

    input:
    tuple val(sampleID), path(sam)

    output:
    tuple val(sampleID), path("${sampleID}.bam"), emit: ch_mapped_bam

    script:
    """
    samtools view -bS -@ ${task.cpus} -o ${sampleID}.bam ${sam}
    """
}