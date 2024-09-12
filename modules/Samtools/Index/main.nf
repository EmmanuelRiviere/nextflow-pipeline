process SAMTOOLS_INDEX {
    tag "${sampleID}"
    publishDir "${params.outName}/BWA", mode: params.publishDirMode

    input:
    tuple val(sampleID), path(sorted_bam)

    output:
    tuple val(sampleID), path("${sorted_bam}.bai"), emit: ch_indexed_bai

    script:
    """
    samtools index ${sorted_bam}
    """
}