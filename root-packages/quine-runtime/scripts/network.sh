# Make network availabe for all your container and it will also let them communicate with each-other

# It will get your current getway ip
getway=$(ip route get 8.8.8.8 | grep -oP '(?<=via )[^ ]*')

#it will add your getway ip to your iptable rules in android

sudo ip route add default via $getway dev wlan0
sudo ip rule add from all lookup main pref 30000
sudo ip rule add pref 1 from all lookup main
sudo ip rule add pref 2 from all lookup default


