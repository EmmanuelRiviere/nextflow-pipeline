process SAMTOOLS_SORT {
    tag "${sampleID}"
    publishDir "${params.outName}/BWA", mode: params.publishDirMode

    input:
    tuple val(sampleID), path(bam)

    output:
    tuple val(sampleID), path("${sampleID}.sorted.bam"), emit: ch_sorted_bam

    script:
    """
    samtools sort -@ ${task.cpus} -o ${sampleID}.sorted.bam ${bam}
    """
}