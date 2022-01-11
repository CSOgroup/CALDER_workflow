library(CALDER)

# We use the demo data to check if CALDER can run smoothly

chrom <- 22
binSize <- 10000
contact_mat_file <- system.file("extdata", "mat_chr22_10kb_ob.txt.gz", package='CALDER')
out_dir <- "./test_CALDER"

CALDER_main(contact_mat_file, 
			chrom, 
			binSize, 
			out_dir, 
			sub_domains=TRUE, 
			save_intermediate_data=FALSE)

# Checking that the files are created


file_exists_not_empty <- function(filepath) {
	filesize <- file.info(filepath)[,"size"]
	return(!is.na(filesize) & (filesize > 0))
}

if(!file_exists_not_empty("./test_CALDER/chr22_domain_boundaries.bed")){
	quit(status=10)
}
if(!file_exists_not_empty("./test_CALDER/chr22_log.txt")){
	quit(status=10)
}
if(!file_exists_not_empty("./test_CALDER/chr22_sub_compartments.bed")){
	quit(status=10)
}
if(!file_exists_not_empty("./test_CALDER/chr22_domain_hierachy.tsv")){
	quit(status=10)
}
if(!file_exists_not_empty("./test_CALDER/chr22_nested_boundaries.bed")){
	quit(status=10)
}
if(!file_exists_not_empty("./test_CALDER/chr22_sub_domains_log.txt")){
	quit(status=10)
}