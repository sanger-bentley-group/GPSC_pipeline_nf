process download_GPS_external_clusters {

    container 'inutano/wget:1.20.3-r1'

    input:
    val(gps_db_external_clusters_url)

    output:
    path("${filename}")

    script:
    filename=file(gps_db_external_clusters_url).getName()
    """
    #!/bin/sh

    wget -q ${gps_db_external_clusters_url}
    """

}
