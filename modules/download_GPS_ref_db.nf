process download_GPS_ref_db {

    container 'bluemoon222/poppunk:2.4.0'

    input:
    val(gps_db)

    output:
    path("${params.gps_db_name}"), emit: db
    val("go"), emit: trigger

    script:
    """
    wget -q ${gps_db}
    tar -xvjf *.tar.bz2
    rm *.tar.bz2
    """

}
