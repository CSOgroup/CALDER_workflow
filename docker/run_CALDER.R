library(CALDER)


args = commandArgs(trailingOnly=TRUE)

contact_mat_file <- args[1]
chr <- args[2]
bin_size <- as.integer(args[3])
out_dir <- args[4]

CALDER_main(contact_mat_file, 
            chr, 
            bin_size, 
            out_dir, 
            sub_domains=TRUE, 
            save_intermediate_data=FALSE)