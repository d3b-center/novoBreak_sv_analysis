cwlVersion: v1.0
class: Workflow
id: novoBreak-germline-workflow
requirements:
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  
inputs:
  input_sample: {type: File, secondaryFiles: ['.crai'], doc: "Input CRAM file"}
  output_basename: string
  cram_conversion_reference_fasta: {type: File, doc: "reference fasta used to
   create CRAM input for conversion to BAM"}
  novoBreak_reference_fasta: {type: File, secondaryFiles: [^.dict, .amb, .ann, .bwt, .pac, .sa],
    doc: "Indexed fasta canonical genome assembly for novoBreak"}

outputs:
  novoBreak_vcf: {type: File, outputSource: run_novoBreak/output}

steps:

  convert_cram_to_bam:
    run: ../tools/samtools_cram2bam.cwl
    in:
      input_reads: input_sample
      threads: 
        valueFrom: ${return 36}
      reference: cram_conversion_reference_fasta
    out: [bam_file]

  generate_control:
    run: ../tools/samtools_generate_novoBreak_control.cwl
    in:
      input_sample: convert_cram_to_bam/bam_file
    out: [output]

  run_novoBreak:
    run: ../tools/run_novoBreak_germline.cwl
    in:
      input_control: generate_control/output
      input_sample: convert_cram_to_bam/bam_file
      output_basename: output_basename
      reference: novoBreak_reference_fasta
    out: [output]

  