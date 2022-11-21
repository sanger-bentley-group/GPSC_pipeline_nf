process get_GPSC {

    container 'staphb/poppunk:2.5.0'

    input:
    path(query_file)
    path(gps_db)
    path(gps_db_external_clusters)

    output:
    path("${output_dir}/${output_dir}_clusters.csv")

    script:
    output_dir="poppunk_clusters"
    poppunk_clusters="${output_dir}/poppunk_clusters_clusters.csv"

    """
    sed -i '1d' ${query_file}
    poppunk_assign --db ${gps_db} --distances ${gps_db}/${gps_db}.dists --query ${query_file} --external-clustering ${gps_db_external_clusters} --output ${output_dir} --threads ${task.cpus}
    """

}
