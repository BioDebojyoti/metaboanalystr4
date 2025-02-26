# Dockerfile for MetaboAnalystR
FROM rocker/r-ver:4.4.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcairo2-dev \
    libnetcdf-dev \
    libxml2 \
    libxt-dev \
    libssl-dev \
    glpk-utils \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://www.bioconductor.org/packages/3.8/bioc/src/contrib/SSPA_2.22.1.tar.gz
RUN wget https://bioconductor.org/packages/release/bioc/src/contrib/sva_3.54.0.tar.gz    
# Install R packages
RUN R -e "install.packages('BiocManager', repos='https://cran.rstudio.com/')"
RUN R -e "BiocManager::install(c('impute', 'pcaMethods', 'globaltest', 'GlobalAncova', 'Rgraphviz', \
        'preprocessCore', 'genefilter', 'SSPA', 'sva', 'limma', 'KEGGgraph', \
        'siggenes', 'BiocParallel', 'MSnbase', 'multtest', 'RBGL', 'edgeR', \
        'fgsea', 'devtools', 'crmn'))"
RUN R -e 'remotes::install_github("Bioconductor/genefilter")'
RUN R -e 'BiocManager::install("qvalue")'
RUN R -e 'install.packages("SSPA_2.22.1.tar.gz", repos=NULL, type="source")'
RUN R -e 'install.packages("sva_3.54.0.tar.gz", repos=NULL, type="source")'
RUN R -e 'BiocManager::install("lgatto/MSnbase")'

# Install MetaboAnalystR
RUN R -e "devtools::install_github('xia-lab/MetaboAnalystR', build = TRUE, build_vignettes = FALSE)"
RUN R -e 'devtools::install_github("xia-lab/OptiLCMS", build = TRUE, build_vignettes = FALSE, build_manual =TRUE)'

ENTRYPOINT ["/bin/bash"]
