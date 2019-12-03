FROM tidair/smurf2mce-base:R2.1.4

# Get the FW MCS from the git repository (version ed07dde0)
WORKDIR /usr/local/src
RUN git clone https://github.com/slaclab/cryo-det.git && \
    mkdir -p /tmp/fw/config && \
    mv ./cryo-det/firmware/targets/MicrowaveMuxBpEthGen2/images/MicrowaveMuxBpEthGen2-0x00000001-20181018084011-mdewart-ed07dde0.mcs.gz /tmp/fw/ &&\
    rm -rf cryo-det && \
    chmod -R a+rw /tmp/fw/

# The pyrogue and config file are modified local copies, which were added to this repository.
# Add then to the docker image
COPY local_files/*pyrogue.tar.gz /tmp/fw/
COPY local_files/*.yml /tmp/fw/config/

WORKDIR /
ENTRYPOINT ["start_server.sh","-S","shm-smrf-sp01","-N","2","-e","smurf_server","-w","smurf_server","-c","eth-rssi-interleaved","-d","/tmp/fw/config/defaults_dspv2_hbonly_c02_bay0.yml","-f","Int16","-b","524288","--disable-bay1"]
