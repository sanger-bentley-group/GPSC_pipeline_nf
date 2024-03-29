/*
 * Nextflow pipeline for getting GPSCs from Pneumococcal Sequences
 *
 * Author:
 * Victoria Carr vc11@sanger.ac.uk
 *
 */

nextflow.enable.dsl=2

// import modules
include { download_GPS_ref_db } from './modules/download_GPS_ref_db.nf'
include { unzip_GPS_ref_db } from './modules/unzip_GPS_ref_db.nf'
include { get_GPSC } from './modules/get_GPSC.nf'
include { add_version } from './modules/add_version.nf'

workflow {

    Channel
    .fromPath(params.manifest, checkIfExists: true)
    .set { poppunk_query_file_ch }

    if (!file(params.gps_db_local).exists()) {

        db_dir = file(params.db_dir)
        db_dir.mkdir()

        download_GPS_ref_db(params.gps_db)
        unzip_GPS_ref_db(download_GPS_ref_db.out)

        unzip_GPS_ref_db.out.db
        .subscribe { it ->
            it.moveTo(file("${params.db_dir}/"))
        }
        get_GPSC(poppunk_query_file_ch, file(params.gps_db_local), params.gps_db_name, unzip_GPS_ref_db.out.trigger)

    } else {

        get_GPSC(poppunk_query_file_ch, file(params.gps_db_local), params.gps_db_name, "go")

    }

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
