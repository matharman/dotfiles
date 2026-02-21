#!/usr/bin/env bash

echo "Make sure you have correct VPN connected"

if [[ "$#" -ne 3 ]] ; then
    echo "Usage: frp_proxy <dev|prod> <proxy_number> <port>"
    exit 1
fi

kubectx=$1
proxy=$2
port=$3

echo "kubectx: $kubectx, proxy:$proxy, port:$port"
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

echo "Starting port-forward on localhost:$port..."

# Start kubectl in the background and capture PID
kubectl -n tunnel-proxy port-forward "deploy/tunnel-proxy$proxy" "$port:$port" &
KUBECTL_PID=$!

# Give kubectl a moment to start
sleep 2

echo "Port-forward started (PID: $KUBECTL_PID)"
echo "Connecting ADB to localhost:$port..."

# Connect to ADB
#adb connect "localhost:$port"
#trap "adb disconnect localhost:$port" EXIT

echo "Setup complete. Press CTRL-C to stop the port-forward."
echo "You can now use:"
echo "adb -s localhost:$port shell"
echo "or:"
echo "scr -s localhost:$port"

# Keep the script running until CTRL-C
while kill -0 "$KUBECTL_PID" 2>/dev/null; do
    sleep 1
done

# If we reach here, kubectl died on its own
echo "Port-forward process ended unexpectedly"
exit 1
