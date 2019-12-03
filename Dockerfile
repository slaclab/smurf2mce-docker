FROM tidair/smurf2mce-base:R3.1.1

# Prepare directory to hold FW and config file
RUN mkdir -p /tmp/fw/config && chmod -R a+rw /tmp/fw/

# Get the FW MCS from the local files on this repository
COPY local_files/MicrowaveMuxBpEthGen2-0x00000020-20190916220655-mdewart-3854241.mcs.gz /tmp/fw/

# Get the pyrogue tarball from the local files on this repository
COPY local_files/MicrowaveMuxBpEthGen2-0x00000020-20190915203851-mdewart-3854241-enpirionDisabled.pyrogue.tar.gz /tmp/fw/

# Get the configuration file from the smurf configuration repository
WORKDIR /tmp
RUN git clone https://github.com/slaclab/smurf_cfg.git -b v0.0.1 && \
    mv ./smurf_cfg/defaults/defaults_lbonly_c03_bay0.yml /tmp/fw/config/ && \
    rm -rf smurf_cfg

WORKDIR /
ENTRYPOINT ["start_server.sh","-d","/tmp/fw/config/defaults_lbonly_c03_bay0.yml","-f","Int16","-b","524288","--disable-bay1"]
