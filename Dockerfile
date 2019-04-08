FROM tidair/smurf2mce-base:R0.0.1

# Get the FW repository (we actually just need the mcs and pyrogue.tar.gz file)
# Needed to fix the githash in the name of the files as it was not correct.
WORKDIR /usr/local/src
RUN git clone https://github.com/slaclab/cryo-det.git && \
	mkdir -p /tmp/fw && \
	mv ./cryo-det/firmware/targets/MicrowaveMuxBpEthGen2/images/MicrowaveMuxBpEthGen2-0x00000001-20181018084011-mdewart-ed07dde0.mcs.gz \
	/tmp/fw/MicrowaveMuxBpEthGen2-0x00000001-20181018084011-mdewart-ed07dde9.mcs.gz && \
    mv ./cryo-det/firmware/targets/MicrowaveMuxBpEthGen2/images/MicrowaveMuxBpEthGen2-0x00000001-20181018084011-mdewart-ed07dde0-newRTM-fastEta-dirty.python.tar.gz \
    /tmp/fw/MicrowaveMuxBpEthGen2-0x00000001-20181018084011-mdewart-ed07dde9-newRTM-fastEta-dirty.python.tar.gz && \
    mv ./cryo-det/firmware/targets/MicrowaveMuxBpEthGen2/config /tmp/fw/ && \
    rm -rf cryo-det && \
    chmod -R a+rw /tmp/fw/

WORKDIR /
ENTRYPOINT ["start_server.sh","-S","shm-smrf-sp01","-N","2","-e","smurf_server","-c","eth-rssi-interleaved","-d","/tmp/fw/config/defaults.yml","-f","Int16","-b","524288"]
