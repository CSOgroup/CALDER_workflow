# We need Bioconductor, so we inherit from their repositorycd .
FROM bioconductor/bioconductor_docker

################
# CALDER SETUP #
################

# Installing GenomicRanges from Bioconductor
RUN R -e "BiocManager::install('GenomicRanges'); if (!library(GenomicRanges, logical.return=T)) quit(status=10)"

# Installing the 'remotes' package, which is used to install CALDER from GitHub
RUN R -e "install.packages('remotes'); if (!library(remotes, logical.return=T)) quit(status=10)"

# Installing CALDER
RUN R -e "remotes::install_github('CSOgroup/CALDER'); if (!library(CALDER, logical.return=T)) quit(status=10)"

# Adding the CALDER testing script
COPY test_CALDER.R ./ 

# Running the testing of CALDER
RUN Rscript test_CALDER.R

# Adding the launching script for CALDER
COPY run_CALDER.R ./

######################
# JUICER TOOLS SETUP #
######################

# Adding the script to download JuicerTools
COPY download_juicertools.sh ./
# Downloading JuicerTools
RUN bash download_juicertools.sh
# Setting environment variable to JuicerTools in the Docker
ENV JUICERTOOLS=/juicer_tools.jar
# Make the JAR executable (optional)
RUN chmod +x /juicer_tools.jar
# Adding function to read metadata of Hi-C
COPY read_hic_metadata.py ./


RUN pip install hic-straw requests

CMD ["R"]
