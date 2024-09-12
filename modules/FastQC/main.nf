process CREATE_FASTQC_REPORT {
	tag {sampleID}

	publishDir "${params.outName}/", mode: params.publishDirMode,
		saveAs: {filename ->
			if (trimming) "Fastqc_trimmed/${filename}"
			else "Fastqc/${filename}"
		}

    input:
	tuple val(sampleID), path(reads)
	val trimming

	output:
	path "*_fastqc.{zip,html}", emit: fastqc_results

	script:
	"""
	fastqc --quiet --threads 4 ${reads}
	"""
}