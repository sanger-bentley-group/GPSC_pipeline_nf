process add_version {

    container 'bash:devel-alpine3.16'

    input:
    file(poppunk_output)

    output:
    path("gpsc_output.csv")

    script:
    version=params.gps_db_name
    """
    #!/usr/local/bin/bash
    head -1 ${poppunk_output} > gpsc_output.csv
    sed -i "s/\$/,db_version/" gpsc_output.csv
    sed -i '1d' ${poppunk_output}
    sed "s/\$/,${version}/" ${poppunk_output} >> gpsc_output.csv
    """

}
