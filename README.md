# Mitochondrial DNA analysis

Includes:
  - Heteroplasmy
  - mtCNV
  - Haplogroup

## Run Nextflow workflow

```
work=/work/dir/

nextflow \
  run get_bam_idxstats.nf \
  -w ${work}

nextflow \
  run mdtna.nf \
  -w ${work}
```
