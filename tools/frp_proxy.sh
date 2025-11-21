#!/usr/bin/env bash

echo "Make sure you have correct VPN connected" && echo
if [[ "$#" -ne 3 ]] ; then
    echo "Usage: frp_proxy <dev|prod> <proxy_number> <port>"
    exit 1
fi

kubectx=$1
proxy=$2
port=$3

echo "kubectx: $kubectx, proxy:$proxy, port:$port"
echo && echo "Logging into AWS SSO..."
aws sso login
if [[ "$kubectx" == "dev" ]]; then
    echo && echo "Switching to DEV context..."
    kubectx dev-flocksafety-eks-charlie
elif [[ "$kubectx" == "prod" ]]; then
    echo && echo "Switching to PROD context..."
    kubectx prod-flocksafety-ue1-charlie-primary
else
    echo "Error: Invalid environment '$kubectx'. Use 'dev' or 'prod'."
    exit 1
fi
echo && echo "After tunnel connects, you can:"
echo "adb connect localhost:$port && adb devices"
echo "adb -s localhost:$port root"
echo "adb -s localhost:$port shell"
echo "or:"
echo "scr -s localhost:$port"
echo && echo "Starting port-forward on localhost:$port..."

kubectl -n tunnel-proxy port-forward "deploy/tunnel-proxy$proxy" "$port:$port"
