cwlVersion: v1.0
class: Workflow
id: novoBreak-somatic-workflow
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  
inputs:
  input_normal: {type: File, secondaryFiles: ['.crai'], doc: "Normal CRAM input file"}
  input_tumor: {type: File, secondaryFiles: ['.crai'], doc: "Tumor CRAM input file"}
  output_basename: string
  cram_conversion_reference_fasta: {type: File, doc: "reference fasta used to
   create CRAM input for conversion to BAM"}
  novoBreak_reference_fasta: {type: File, secondaryFiles: [^.dict, .amb, .ann, .bwt, .pac, .sa],
    doc: "Indexed fasta canonical genome assembly for novoBreak"}

outputs:
  novoBreak_vcf: {type: File, outputSource: run_novoBreak/output}

steps:

  convert_cram_to_bam_normal:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_normal
      threads: 
        valueFrom: ${return 36}
      reference: cram_conversion_reference_fasta
    out: [bam_file]
    
  convert_cram_to_bam_tumor:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_tumor
      threads:
        valueFrom: ${return 36}
      reference: cram_conversion_reference_fasta
    out: [bam_file]

  run_novoBreak:
    run: ../tools/run_novoBreak.cwl
    in:
      input_normal: convert_cram_to_bam_normal/bam_file
      input_tumor: convert_cram_to_bam_tumor/bam_file
      output_basename: output_basename
      reference: novoBreak_reference_fasta
    out: [output]

$namespaces:
  sbg: https://sevenbridges.com
hints:
  - class: 'sbg:maxNumberOfParallelInstances'
    value: 2