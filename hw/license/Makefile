ETH0_MAC := $(shell ip link show eth0 | awk '/link\/ether/ {print $$2}')

all:
	@/opt/questa/genlicense/python2/bin/python2 /opt/questa/genlicense/mgclicgen.py $(ETH0_MAC)
	@mv ./license.dat /opt/questa
	@/opt/questa/pubkey_verify -y
	@echo "================================="
	@echo "License approved!"
	@echo "================================="
	@vlog -version
	@vsim -version
