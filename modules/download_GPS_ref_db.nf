process download_GPS_ref_db {

    container 'bluemoon222/gpsc_pipeline:0.0.1'

    input:
    file(gps_db)

    output:
    path("${params.gps_db_name}"), emit: db
    val("go"), emit: trigger

    script:
    gps_db_name=params.gps_db_name
    """
    wget -q ${gps_db}
    unzip ${gps_db_name}.zip
    rm *.zip
    """

}
