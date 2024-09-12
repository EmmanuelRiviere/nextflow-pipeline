# DNAseq Nextflow Processing Pipeline

## Description

This Nextflow script implements a simple pipeline for processing DNA sequencing data. The pipeline performs quality control, read trimming, mapping to a reference genome, and BAM file processing.

## Overview

This pipeline performs the following steps:

1. Quality control on raw reads (FastQC)
2. Read trimming for quality and length (Fastp)
3. Quality control on trimmed reads (FastQC)
4. Mapping reads to a reference genome (BWA)
5. Convert SAM to BAM (Samtools)
6. Sort BAM file (Samtools)
7. Index BAM file (Samtools)

## Requirements

- Nextflow (version 24.04.4)
- FastQC (version 0.12.1)
- Fastp (version 0.23.4)
- BWA (version 0.7.18)
- Samtools (version 1.20)

## Usage

To run the pipeline, use the following command:

```
nextflow run main.nf --inputDir <path_to_fastq_directory> --referenceDir <path_to_reference_directory> --outputDir <path_to_output_directory>
```

### Parameters

- `--runName`: Name of the run (required)
- `--reads`: Path to input reads (paired-end FASTQ files)
- `--referenceDir`: Path to the directory containing BWA index files for hg38

## Input

- Paired-end FASTQ files (inputDir)
- BWA index files for hg38 reference genome (refenceDir)

## Output

The pipeline generates the following outputs:

- FastQC reports for raw and trimmed reads
- Trimmed FASTQ files
- Mapped SAM files
- Sorted and indexed BAM files
