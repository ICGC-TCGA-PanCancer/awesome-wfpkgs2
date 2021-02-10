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

// include section starts
include { FastqcWf2 } from "./wfpr_modules/github.com/icgc-tcga-pancancer/awesome-wfpkgs2/fastqc-wf2@0.1.2/fastqc-wf2"
include { cleanupWorkdir } from "./wfpr_modules/github.com/icgc-argo/demo-wfpkgs/demo-utils@1.2.0/main"

// include section ends


workflow FastqcWf3 {
  take:  // update as needed
    // input section starts
    input_file
    // input section ends

  main:  // update as needed
    // main section starts
    FastqcWf2(input_file)

    cleanupWorkdir(FastqcWf2.out, true)
    // main section ends

  emit:  // update as needed
    // output section starts
    output_file = FastqcWf2.out.output_file
    // output section ends
}
