FROM public.ecr.aws/lambda/provided

# Install wget and other necessary packages
RUN dnf -y install wget openssl-devel

# Install R from CRAN
RUN dnf -y install R

# System requirements for R packages
RUN dnf -y install libcurl-devel libxml2-devel openssl-devel

# Install necessary R packages
RUN Rscript -e "install.packages(c('httr', 'jsonlite', 'logger'), repos = 'https://cloud.r-project.org/')"

# Copy runtime and function scripts
COPY scripts/* ${LAMBDA_TASK_ROOT}/
RUN chmod 755 -R ${LAMBDA_TASK_ROOT}/

RUN printf '#!/bin/sh\ncd $LAMBDA_TASK_ROOT\nRscript bootstrap.R' > /var/runtime/bootstrap \
  && chmod +x /var/runtime/bootstrap

CMD [ "functions.myRcode" ]
