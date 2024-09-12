process BWA_MAPPING {
    tag "${sampleID}"
    publishDir "${params.outName}/BWA", mode: params.publishDirMode

    input:
    tuple val(sampleID), path(reads)
    path(bwa_index)

    output:
    tuple val(sampleID), path("${sampleID}.sam"), emit: ch_mapped_sam

    script:
    def index_base = bwa_index.find { it.toString().endsWith(".amb") }.toString() - ~/.amb$/
    """
    bwa mem -t ${task.cpus} \
        -R "@RG\\tID:${sampleID}\\tSM:${sampleID}\\tPL:ILLUMINA" \
        ${index_base} \
        ${reads[0]} ${reads[1]} > ${sampleID}.sam
    """
}