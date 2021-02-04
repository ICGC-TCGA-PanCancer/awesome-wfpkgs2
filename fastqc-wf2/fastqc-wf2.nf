#!/usr/bin/env nextflow

nextflow.enable.dsl = 2
version = '0.1.0'  // package version

// universal params go here, change default value as needed
params.container_version = ""
params.cpus = 1
params.mem = 1  // GB
params.publish_dir = ""  // set to empty string will disable publishDir

// tool specific parmas go here, add / change as needed
params.input_file = ""
params.output_pattern = "*.html"  // fastqc output html report

include { fastqc } from "./wfpr_modules/github.com/icgc-tcga-pancancer/awesome-wfpkgs1/fastqc@0.2.0/fastqc"
include { FastqcWf } from "./wfpr_modules/github.com/icgc-tcga-pancancer/awesome-wfpkgs2/fastqc-wf@0.2.0/fastqc-wf"
include { cleanupWorkdir } from "./wfpr_modules/github.com/icgc-argo/demo-wfpkgs/demo-utils@1.1.0/main"



workflow FastqcWf2 {
  take:  // input, make update as needed
    input_file

  main:
    FastqcWf(input_file)

    cleanupWorkdir(FastqcWf.out, true)

  emit:
    output_file = FastqcWf.out.output_file
}
