#!/usr/bin/env nextflow

/*
 This is an auto-generated checker workflow, please update as needed
*/

nextflow.enable.dsl = 2
version = '0.1.0'  // package version

// universal params
params.publish_dir = ""
params.container_version = ""

// tool specific parmas go here, add / change as needed
params.input_file = ""
params.expected_output = ""

include { FastqcWf3 } from '../fastqc-wf3'
// include statements go here for dev dependencies

Channel
  .fromPath(params.input_file, checkIfExists: true)
  .set { input_file }


process file_diff {
  input:
    path output_file
    path expected_gzip

  output:
    stdout()

  script:
    """
    # remove date field before comparison eg, <div id="header_filename">Tue 19 Jan 2021<br/>test_rg_3.bam</div>
    # sed -e 's#"header_filename">.*<br/>test_rg_3.bam#"header_filename"><br/>test_rg_3.bam</div>#'

    diff <( cat ${output_file} | sed -e 's#"header_filename">.*<br/>test_rg_3.bam#"header_filename"><br/>test_rg_3.bam</div>#' ) \
         <( gunzip -c ${expected_gzip} | sed -e 's#"header_filename">.*<br/>test_rg_3.bam#"header_filename"><br/>test_rg_3.bam</div>#' ) \
    && ( echo "Test PASSED" && exit 0 ) || ( echo "Test FAILED, output file mismatch." && exit 1 )
    """
}


workflow checker {
  take:
    input_file
    expected_output

  main:
    FastqcWf3(
      input_file
    )

    file_diff(
      FastqcWf3.out.output_file,
      expected_output
    )
}


workflow {
  checker(
    file(params.input_file),
    file(params.expected_output)
  )
}
