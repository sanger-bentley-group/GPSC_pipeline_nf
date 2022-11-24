process get_GPSC {

    container 'staphb/poppunk:2.5.0'

    input:
    path(query_file)
    path(gps_db)
    path(gps_db_external_clusters)

    output:
    path("${output_dir}/${output_dir}_external_clusters.csv")

    script:
    output_dir="poppunk_clusters"

    """
    sed -i '1d' ${query_file}
    sed -i 's/^/prefix_/' ${query_file}
    poppunk_assign --db ${gps_db} --query ${query_file} --external-clustering ${gps_db_external_clusters} --output ${output_dir} --threads ${task.cpus}
    sed -i 's/prefix_//' ${output_dir}/${output_dir}_external_clusters.csv
    """

}
