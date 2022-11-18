process download_GPS_ref_db {

    container 'inutano/wget:1.20.3-r1'

    input:
    val(gps_db)

    output:
    path("${params.gps_db_name}.zip")

    script:
    """
    #!/bin/sh
    
    wget -q ${gps_db}
    """

}
