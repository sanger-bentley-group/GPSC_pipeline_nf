# GPSC Pipeline

## Quick start

### Installation
GBS Typer relies on Nextflow and Docker.
Download:
1. [Docker](https://www.docker.com/).
2. [Nextflow](https://www.nextflow.io/).
3. Clone repository:
```
git clone https://github.com/sanger-bentley-group/GPSC_pipeline_nf.git
cd GPSC_pipeline_nf
```

### Run pipeline
```
nextflow run main.nf --manifest your_manifest.txt --results_dir results
```

Your manifest `your_manifest.txt` must be a tab-delimited file with headers `sample_id` and `assembly`, e.g.

sample_id | assembly
:---: | :---:
sample1 | /location/of/assembly/file1.fa
sample2 | /location/of/assembly/file2.fa

The first time you run the pipeline, it will download the `GPS_v6` database in a `db` directory (within the current directory where you run the pipeline). If you would like to use an existing `GPS_v6` database instead (and not re-download it), create a directory called `db` and move/symlink your `GPS_v6` database.

### Output
csv file `gps_output.csv` in `results_dir`, e.g.:
```
Taxon,Cluster,db_version
12291_4#66,1,GPS_v6
12291_4#65,1,GPS_v6
12291_4#69,1,GPS_v6
```

### Test pipeline
This test checks whether the output is expected.
```
./tests/regression_tests.sh
```
