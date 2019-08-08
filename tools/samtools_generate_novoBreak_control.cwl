cwlVersion: v1.0
class: CommandLineTool
id: samtools-generate-novoBreak-control
requirements:
  - class: ShellCommandRequirement
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMin: 24000
  - class: DockerRequirement
    dockerPull: 'kfdrc/samtools:1.9'
baseCommand: ["/bin/bash", "-c"]
arguments:
  - position: 1
    shellQuote: false
    valueFrom: >-
      set -eo pipefail
      
      samtools view -H $(inputs.input_sample.path) | samtools view -Sb - > control.bam
      && samtools index control.bam control.bai

inputs:
  input_sample:
    type: File
    label: Input sample to generate mock normal or control

outputs:
  output:
    type: File
    outputBinding:
      glob: '*.bam'
    secondaryFiles: [^.bai]