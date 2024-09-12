// Enable dsl2 syntax
nextflow.enable.dsl=2

/*
================================================================================
    VALIDATE COMMAND LINE PARAMETERS
================================================================================
*/
// Check inputDir
if ( !params.inputDir ) { exit 1, "The 'inputDir' parameter is undefined" }

// Check inputDir
if ( !params.referenceDir ) { exit 1, "The 'referenceDir' parameter is undefined" }

// Check outputDir
if ( !params.outputDir ) { exit 1, "The 'outputDir' parameter is undefined" }

/*
================================================================================
    INCLUDE MODULES AND/OR MODULE COMPONENTS
================================================================================
*/

include {
    CREATE_FASTQC_REPORT as CREATE_FASTQC_REPORT_RAW
} from "./modules/FastQC/main.nf"

include {
    CREATE_FASTQC_REPORT as CREATE_FASTQC_REPORT_TRIMMED
} from "./modules/FastQC/main.nf"

include {
    FASTP_TRIMMING
} from "./modules/Fastp/main.nf"

include {
    BWA_MAPPING
} from "./modules/Mapping/BWA/main.nf"

include {
    SAMTOOLS_SAM_TO_BAM
} from "./modules/Samtools/View/main.nf"

include {
    SAMTOOLS_SORT
} from "./modules/Samtools/Sort/main.nf"

include {
    SAMTOOLS_INDEX
} from "./modules/Samtools/Index/main.nf"

/*
================================================================================
    INITIALIZE CHANNELS
================================================================================
*/

Channel
    .fromFilePairs( params.reads, size: 2 )
    .ifEmpty { exit 1, "Cannot find any reads matching: ${params.reads}" }
    .set { ch_raw_reads }

Channel
    .fromPath("${params.referenceDir}/*")
    .collect()
    .ifEmpty { exit 1, "Cannot find reference files reads matching: ${params.referenceDir}/*" }
    .set { ch_bwa_index }

/*
================================================================================
    DEFINE MAIN WORKFLOW
================================================================================
*/

workflow{
    
    // Check raw QC
    CREATE_FASTQC_REPORT_RAW( ch_raw_reads, false )

    // Perfrom read trimming (quality and length)
    FASTP_TRIMMING ( ch_raw_reads )

    // Check QC of trimmed reads
    CREATE_FASTQC_REPORT_TRIMMED( FASTP_TRIMMING.out.ch_fastp_reads, true )

    // Mapping to reference genome
    BWA_MAPPING( FASTP_TRIMMING.out.ch_fastp_reads, ch_bwa_index )

    // Convert Sam to Bam
    SAMTOOLS_SAM_TO_BAM( BWA_MAPPING.out.ch_mapped_sam )

    // Sort BAM
    SAMTOOLS_SORT( SAMTOOLS_SAM_TO_BAM.out.ch_mapped_bam )

    // Index BAM
    SAMTOOLS_INDEX( SAMTOOLS_SORT.out.ch_sorted_bam )
}