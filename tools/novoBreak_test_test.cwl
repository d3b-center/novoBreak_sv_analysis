class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: novo_break_test_tool
baseCommand: []
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
  - id: reference
    type: File
    secondaryFiles: [.64.amb, .64.ann, .64.bwt, .64.pac,
      .64.sa, .64.alt, ^.dict, .amb, .ann, .bwt, .pac, .sa]
    label: Fasta genome assembly

outputs:
  - id: output
    type: File
    outputBinding:
      glob: '*.vcf'
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      run_novoBreak.sh /nb_distribution
      $(inputs.reference.path) 
      $(inputs.input_tumor.path)
      $(inputs.input_normal.path) 
      16 
      $(inputs.output_basename)/
      && mv $(inputs.output_basename)/*.vcf $(inputs.output_basename).break.vcf
requirements:
  - class: ShellCommandRequirement
  - class: ResourceRequirement
    ramMin: 42000
    coresMin: 16
  - class: DockerRequirement
    dockerPull: 'bmennis/novobreak'
  - class: InlineJavascriptRequirement
