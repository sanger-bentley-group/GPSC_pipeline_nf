process unzip_GPS_ref_db {

    container 'joshkeegan/zip:3.16.3'

    input:
    file(gps_db_zip)

    output:
    path("${params.gps_db_name}"), emit: db
    val("go"), emit: trigger

    script:
    gps_db_name=params.gps_db_name
    """
    #!/bin/sh

    unzip ${gps_db_zip} -d ${gps_db_name}
    #rm "\$(readlink -f ${gps_db_zip})"
    """

}
