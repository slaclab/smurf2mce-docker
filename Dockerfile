FROM tidair/smurf2mce-base:R2.1.4

# Prepare directory to hold FW and config file
RUN mkdir -p /tmp/fw/config && chmod -R a+rw /tmp/fw/

# Get the FW MCS from the git repository
WORKDIR /tmp
RUN git clone https://github.com/slaclab/cryo-det.git && \
	cd cryo-det && \
	git checkout 26ed168478222480e68fec62bfdfa16164173ddd && \
	mv ./firmware/targets/MicrowaveMuxBpEthGen2/images/MicrowaveMuxBpEthGen2-0x00000016-20190724191903-mdewart-8234f45.mcs.gz  /tmp/fw/ && \
	cd .. && \
    rm -rf cryo-det

# Get the pyrogue tarball from the local files on this repository
COPY local_files/MicrowaveMuxBpEthGen2-0x00000016-20190724191903-mdewart-8234f45-etaMagFix.pyrogue.tar.gz /tmp/fw

# Get the configuration file from the smurf configuration repository
WORKDIR /tmp
RUN git clone https://github.com/slaclab/smurf_cfg.git -b v0.0.0 && \
	mv ./smurf_cfg/defaults/defaults_lbonly_c02_bay0.yml /tmp/fw/config/ && \
	rm -rf smurf_cfg

WORKDIR /
ENTRYPOINT ["start_server.sh","-S","shm-smrf-sp01","-c","eth-rssi-interleaved","-d","/tmp/fw/config/defaults_lbonly_c02_bay0.yml","-f","Int16","-b","524288","--disable-bay1"]
