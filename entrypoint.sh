#!/usr/bin/env sh

set -ueo pipefail

# aws s3 cp ${S3_CERT_PEM} /etc/cloudflared/

# echo -e "url: ${ORIGIN_DNS}
# hostname: ${TUNNEL_HOSTNAME}" > /etc/cloudflared/config.yml 

# set +ex

# for i in {1..60}; do
#   wget ${ORIGIN_DNS} 1>/dev/null 2>&1

#   if [ $? -ne 0 ]; then
#     echo "Failed to connect to ${ORIGIN_DNS}"
#     sleep 1
#   else
#     echo "Successfully connected to ${ORIGIN_DNS}"
#     break
#   fi
# done

set -ex

cloudflared tunnel --no-autoupdate
