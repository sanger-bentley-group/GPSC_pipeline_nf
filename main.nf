/*
 * Nextflow pipeline for getting GPSCs from Pneumococcal Sequences
 *
 * Author:
 * Victoria Carr vc11@sanger.ac.uk
 *
 */

nextflow.enable.dsl=2

// import modules
include { download_GPS_external_clusters } from './modules/download_GPS_external_clusters.nf'
include { download_GPS_ref_db } from './modules/download_GPS_ref_db.nf'
include { unzip_GPS_ref_db } from './modules/unzip_GPS_ref_db.nf'
include { get_GPSC } from './modules/get_GPSC.nf'
include { add_version } from './modules/add_version.nf'

workflow {

    // Create poppunk query channel
    Channel
    .fromPath(params.manifest, checkIfExists: true)
    .set { poppunk_query_file_ch }

    // Create db directory if needed
    db_dir = file(params.db_dir)
    db_dir.mkdir()

    // Get GPS external clusters
    if (!file(params.gps_db_external_clusters).exists()) {

        download_GPS_external_clusters(params.gps_db_external_clusters_url)
        download_GPS_external_clusters.out
        .subscribe { it ->
            it.moveTo(file("${params.db_dir}/"))
        }
        gps_db_external_clusters=file(params.gps_db_external_clusters)

    } else {

        gps_db_external_clusters=file(params.gps_db_external_clusters)

    }

    // Get GPS db
    if (!file(params.gps_db).exists()) {

        download_GPS_ref_db(params.gps_db_url)
        unzip_GPS_ref_db(download_GPS_ref_db.out)

        unzip_GPS_ref_db.out.db
        .subscribe { it ->
            it.moveTo(file("${params.db_dir}/"))
        }
        gps_db_local=file(params.gps_db)

    } else {

        gps_db_local=file(params.gps_db)

    }

    // Run popPUNK
    get_GPSC(poppunk_query_file_ch, gps_db_local, gps_db_external_clusters)

    // Add version
    add_version(get_GPSC.out)

    // Publish GPSCs
    results_dir = file(params.results_dir)
    results_dir.mkdir()
    add_version.out
    .subscribe { it ->
        it.copyTo(file("${results_dir}"))
    }
}
