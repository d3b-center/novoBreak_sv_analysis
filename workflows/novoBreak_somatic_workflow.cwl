cwlVersion: v1.0
class: Workflow
id: novoBreak-somatic-workflow
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  
inputs:
  input_normal: 
    type: File
    label: Normal CRAM input file
  input_tumor:
    type: File
    label: Tumor CRAM input file
  output_basename: 
    type: string
    label: Output name
  analysis_type:
    type: string
    label: Type of analysis e.g. somatic, germline
  cram_conversion_reference_fasta:
    type: File
    label: reference fasta used to create CRAM input for conversion to BAM
  novoBreak_reference_fasta: 
    type: File
    secondaryFiles: [^.dict, .amb, .ann, .bwt, .pac, .sa]
    label: Indexed fasta canonical genome assembly for novoBreak
  threads:
    type: int
    label: Amount of threads to convert CRAM to BAM

outputs:
  novoBreak_vcf:
    type: File
    outputSource: run_novoBreak/output

steps:

  convert_cram_to_bam_normal:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_normal
      threads: threads
      reference: cram_conversion_reference_fasta
    out: [bam_file]
    
  convert_cram_to_bam_tumor:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_tumor
      threads: threads
      reference: cram_conversion_reference_fasta
    out: [bam_file]

  run_novoBreak:
    run: ../tools/run_novoBreak.cwl
    in:
      input_normal: convert_cram_to_bam_normal/bam_file
      input_tumor: convert_cram_to_bam_tumor/bam_file
      output_basename: output_basename
      analysis_type: analysis_type
      reference: novoBreak_reference_fasta
    out: [output]

  