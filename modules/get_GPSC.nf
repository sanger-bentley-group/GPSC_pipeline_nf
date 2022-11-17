process get_GPSC {

    container 'bluemoon222/gpsc_pipeline:0.0.1'

    input:
    path(query_file)
    path(ref_db)
    val(gps_db_name)
    val(trigger)

    output:
    path("${output_dir}/${output_dir}_clusters.csv")

    script:
    output_dir="poppunk_clusters"
    poppunk_clusters="${output_dir}/poppunk_clusters_clusters.csv"

    """
    sed -i '1d' ${query_file}
    poppunk_assign --db ${ref_db} --distances ${ref_db}/${gps_db_name}.dists --query ${query_file} --output ${output_dir} --threads ${task.cpus}
    """

}
