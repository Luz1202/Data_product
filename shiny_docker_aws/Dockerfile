FROM rocker/r-base:latest
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install.r shiny plotly dplyr DT shinythemes markdown shinyWidgets rsconnect tidyverse ggplot2 readr

RUN echo "local(options(shiny.port = 3838, shiny.host = '0.0.0.0'))" > /usr/lib/R/etc/Rprofile.site
RUN addgroup --system dataproduct \
    && adduser --system --ingroup dataproduct student

WORKDIR /home/dataproduct
COPY /. /home/dataproduct
RUN chown student:dataproduct -R /home/dataproduct
USER student
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/home/dataproduct')"]