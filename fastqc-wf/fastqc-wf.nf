#!/usr/bin/env nextflow

nextflow.enable.dsl = 2
version = '0.2.0'  // package version

// universal params go here, change default value as needed
params.container_version = ""
params.cpus = 1
params.mem = 1  // GB
params.publish_dir = ""  // set to empty string will disable publishDir

// tool specific parmas go here, add / change as needed
params.input_file = ""
params.output_pattern = "*.html"  // fastqc output html report

include { fastqc } from "./wfpr_modules/github.com/icgc-tcga-pancancer/awesome-wfpkgs1/fastqc@0.2.0/fastqc"
include { cleanupWorkdir } from "./wfpr_modules/github.com/icgc-argo/demo-wfpkgs/demo-utils@1.1.0/main"



workflow FastqcWf {
  take:  // input, make update as needed
    input_file

  main:
    fastqc(input_file)

    cleanupWorkdir(fastqc.out, true)

  emit:
    output_file = fastqc.out.output_file
}
