cwlVersion: v1.0
class: CommandLineTool
id: novoBreak-sv-somatic-temp
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 42000
    coresMin: 16
  - class: DockerRequirement
    dockerPull: 'bmennis/novobreak'
baseCommand: [bash]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      nb_distribution/run_novoBreak.sh nb_distribution/ $(inputs.reference.path) $(inputs.input_tumor.path) $(inputs.input_normal.path) 16 $(inputs.output_basename)/

inputs:
  reference: { type: File,  secondaryFiles: [.fai], label: Fasta genome assembly with index }
  input_tumor:
    type: File
  input_normal:
    type: File
  output_basename: string

outputs:
  output:
    type: File
    outputBinding:
      glob: '*.vcf'