process check_output {

    container 'bash:devel-alpine3.16'

    input:
    file(poppunk_output)
    file(manifest)

    output:
    stdout

    script:
    results_dir=params.results_dir
    """
    #!/usr/local/bin/bash
    num_manifest_lines=\$(cat ${manifest} | grep '\t' | wc -l)
    num_poppunk_lines=\$(cat ${poppunk_output} | grep , | wc -l)
    sample_num=\$(( \${num_poppunk_lines} - 1 ))
    manifest_num=\$(( \${num_manifest_lines} - 1 ))
    if [ \${num_manifest_lines} -eq \${num_poppunk_lines} ]
    then
        echo ""
        echo -e "Successfully completed GPSC assignment for all \${sample_num} samples. Results available in ${results_dir}/${poppunk_output}"
    else
        echo -e "Not all samples successful. \${sample_num} samples detected in results ${results_dir}/${poppunk_output} compared to \${manifest_num} samples in manifest."
    fi
    """

}
