# Setup Can0 interface to forward traffic to klipper docker container.
DOCKERPID=$(docker inspect -f '{{ .State.Pid }}' prind-klipper-1)
sudo ip link add vxcan0 type vxcan peer name vxcan1
sudo ip link set vxcan1 netns $DOCKERPID
sudo ip link set vxcan0 up
sudo nsenter -t $DOCKERPID -n ip link set vxcan1 up

# Forward traffic from can0 to vxcan interface
sudo cangw -A -s can0 -d vxcan0 -e
sudo cangw -A -s vxcan0 -d can0 -e

# Bring up can0 interface
sudo ip link set can0 type can bitrate 250000
sudo ip link set up can0