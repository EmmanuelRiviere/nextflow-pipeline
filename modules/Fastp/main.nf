process FASTP_TRIMMING {
	tag {sampleID}

	publishDir "${params.outName}/Fastp", mode: params.publishDirMode

    input:
	tuple val(sampleID), path(reads)

	output:
	tuple val(sampleID), path("*fq.gz"), emit: ch_fastp_reads
	path("*fastp.json"), emit: ch_fastp_report
	path("*.html")

	script:
	"""
	fastp \
	-i ${reads[0]} \
    -I ${reads[1]} \
    -o ${reads[0].baseName}.fq.gz \
    -O ${reads[1].baseName}.fq.gz \
	-q ${params.qualityCutoff} \
	-l ${params.readLengthFilter} \
    -D \
    --cut_right_window_size 4 \
    --cut_right_mean_quality 30 \
    --trim_poly_g \
    --poly_g_min_len 10 \
    --detect_adapter_for_pe \
	--thread 4 \
	-h ${sampleID}_fastp.html \
	-j ${sampleID}_fastp.json \
	"""
}