# CALDER workflow

Docker image and Nextflow workflow quickly use the [CALDER software](https://github.com/CSOgroup/CALDER) for the analysis of Hi-C data.

## Docker image
This workflow uses the following docker image, containing all the dependencies required to execute it

[![dockeri.co](https://dockeri.co/image/lucananni93/calder)](https://hub.docker.com/r/lucananni93/calder)


## Usage

Currently, the pipeline accepts a (list of) `.hic` files

### Minimal example:
```
nextflow run calder.nf --input path/to/hic/data.hic
```

## Parameters

| Parameter | Values | Description |
| --------- | ------ | ----------- |
| --input  | path (ex. `./data.hic`) | Path to `.hic` files. Can contain wildcards (*) |
| --chromosomes | "ALL" or a comma-separated list of chromosomes (ex. "1,2,3") | If "ALL", then all the chromosomes in the `.hic` file will be computed, otherwise only the ones provided in the list. (**Default: "ALL"**)|
| --excludeChromosomes | Comma-separated list of chromosomes (ex. "1,2,3") | Excludes the specified chromosomes from the computation (**Default: "Y,MT"**)|
| --binSize | Comma-separated list of resolutions (ex. "100000,250000") | Specifies at which resolutions the CALDER workflow should be performed. (**Default: "100000"**) |
| --normalization | Comma-separated list of Hi-C normalization strategies (ex. "KR,VC") | Specifies which Hi-C normalizatios to use. (**Default: "KR"**) |
| --out_dir | Path to the results folder (ex. "./results") | Specifies where to store the results of the analysis (**Default: "results"**) | 

## Output Structure
The output of the workflow is stored in the folder specified by `--out_dir` ("results" by default) and will look like this:
```
results/
└── HiC_sample_1
    ├── 100000
    │   └── KR
    │       ├── chr1
    │       │   ├── chr1_domain_boundaries.bed
    │       │   ├── chr1_domain_hierachy.tsv
    │       │   ├── chr1_log.txt
    │       │   ├── chr1_nested_boundaries.bed
    │       │   ├── chr1_sub_compartments.bed
    │       │   └── chr1_sub_domains_log.txt

```

The specification of the output of CALDER is described [in the respective repository](https://github.com/CSOgroup/CALDER).

## Citation
If you use CALDER, this workflow or the relative Docker image in our research, please cite our paper:

- Liu, Y., Nanni, L., Sungalee, S. et al. Systematic inference and comparison of multi-scale chromatin sub-compartments connects spatial organization to cell phenotypes. Nat Commun 12, 2439 (2021). https://doi.org/10.1038/s41467-021-22666-3
