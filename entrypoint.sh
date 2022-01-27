#!/usr/bin/env sh

set -ueo pipefail

mkdir /etc/cloudflared

cat << EOF > /etc/cloudflared/config.yaml 
tunnel: $CLOUDFLARED_TUNNEL_UUID
credentials-file: /etc/cloudflared/$CLOUDFLARED_TUNNEL_UUID.json
warp-routing:
  enabled : true
EOF

echo $CLOUDFLARED_TUNNEL_CREDENTIALS > /etc/cloudflared/$CLOUDFLARED_TUNNEL_UUID.json 

# set +ex

# for i in $(echo $TUNNELED_NETWORKS | awk 1 RS=,); do 
#     echo $i; done

# set -ex

cloudflared tunnel run
