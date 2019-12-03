FROM tidair/smurf2mce-base:R2.1.4

# Definitions
## MCS file name and commit where it is found on the cryo-det repository
ENV mcs_commit 	26ed168478222480e68fec62bfdfa16164173ddd
ENV mcs_name	MicrowaveMuxBpEthGen2-0x00000016-20190724191903-mdewart-8234f45.mcs.gz
## Configuration file name and version where it is found on the smurf_cfg repository
ENV config_ver	v0.0.0
ENV config_file	defaults_lbonly_c02_bay0.yml

# Prepare directory to hold FW and config file
RUN mkdir -p /tmp/fw/config && chmod -R a+rw /tmp/fw/

# Get the FW MCS from the git repository
WORKDIR /tmp
RUN git clone https://github.com/slaclab/cryo-det.git && \
	cd cryo-det && \
	git checkout ${mcs_commit} && \
	mv ./firmware/targets/MicrowaveMuxBpEthGen2/images/${mcs_name}  /tmp/fw/ && \
	cd .. && \
    rm -rf cryo-det

# Get the pyrogue tarball from the local files on this repository
COPY local_files/MicrowaveMuxBpEthGen2-0x00000016-20190724191903-mdewart-8234f45-etaMagFix.pyrogue.tar.gz /tmp/fw

# Get the configuration file from the smurf configuration repository
WORKDIR /tmp
RUN git clone https://github.com/slaclab/smurf_cfg.git -b ${config_ver} && \
	mv ./smurf_cfg/defaults/${config_file} /tmp/fw/config/ && \
	rm -rf smurf_cfg

WORKDIR /
ENTRYPOINT ["start_server.sh","-d","/tmp/fw/config/${config_file}","-f","Int16","-b","524288","--disable-bay1"]
