#!/usr/bin/env nextflow



input_hic_file_channel = Channel.fromPath("/mnt/ndata/Juan/HiC-maps/RPE_Control.hic")


params.chromosomes = '1,2,3'
params.binSize = "100000,1000000"
params.out_dir = "./test_CALDER"
params.normalization = 'KR,NONE'


input_hic_file_channel.into { 
    input_hic_file_chroms;
    input_hic_file_contacts 
}


process get_resolutions {
    output:
    stdout resolutions

    """
    #!/usr/bin/env bash

    echo "${params.binSize}" | tr ',' '\n'
    """
}



process get_normalizations {
    output:
    stdout normalizations

    """
    #!/usr/bin/env bash

    echo "${params.normalization}" | tr ',' '\n'
    """
}



process get_chromosomes {

    input:
    file input_hic_file from input_hic_file_chroms

    output:
    stdout chromosomes

    """
    #!/usr/bin/env python3

    from straw import getResolutions, getChromosomes

    if "${params.chromosomes}" == "ALL":
        for v in getChromosomes("${input_hic_file}"):
            if v.name not in ['ALL']:
                print(v.name)
    else:
        for v in "${params.chromosomes}".strip().split(","):
            print(v)

    """
}


process dump_chromosomes {
    input:
    file input_hic_file from input_hic_file_contacts
    each chrom from chromosomes.splitText().map{x -> x.strip()}
    each binSize from resolutions.splitText().map{x -> x.strip() as Integer}
    each norm from normalizations.splitText().map{x -> x.strip()}

    output:
    tuple val(chrom), val(binSize), val(norm), file("dump.txt") into chromosome_dumps
    """
    #!/usr/bin/env bash

    java -jar \${JUICERTOOLS} dump observed \\
                             ${norm} \\
                             ${input_hic_file} \\
                             ${chrom} \\
                             ${chrom} \\
                             BP \\
                             ${binSize} \\
                             "dump.txt"
    """
}


process run_CALDER {

    input:
    tuple val(chrom), val(binSize), val(normalization), file("dump.txt") from chromosome_dumps

    output:
    tuple val(chrom), val(binSize), val(normalization), path('calder') into calder_out

    """
    #!/usr/bin/env Rscript

    library(CALDER)
    CALDER_main("dump.txt", 
                "${chrom}", 
                 ${binSize},  
                "calder", 
                sub_domains=TRUE, 
                save_intermediate_data=FALSE)
    """
}




