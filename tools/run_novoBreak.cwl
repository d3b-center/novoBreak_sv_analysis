cwlVersion: v1.0
class: CommandLineTool
id: run-novoBreak
requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: 'bmennis/novobreak'
  - class: ResourceRequirement
    ramMin: 42000
    coresMin: 36
  - class: InlineJavascriptRequirement
  
baseCommand: []
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      run_novoBreak.sh /nb_distribution
      $(inputs.reference.path)
      $(inputs.input_tumor.path)
      $(inputs.input_normal.path)
      36
      $(inputs.output_basename)/
      && mv $(inputs.output_basename)/*.vcf $(inputs.output_basename).novoBreak_somatic.vcf
      
inputs:
  - id: input_normal
    type: File
    secondaryFiles: [^.bai]
    label: Normal BAM input file with index
  - id: input_tumor
    type: File
    secondaryFiles: [^.bai]
    label: Tumor BAM input file with index
  - id: output_basename
    type: string
    label: Output basename
  - id: reference
    type: File
    secondaryFiles: [^.dict, .amb, .ann, .bwt, .pac, .sa]
    label: Indexed fasta genome assembly

outputs:
  - id: output
    type: File
    outputBinding:
      glob: '*.vcf'


