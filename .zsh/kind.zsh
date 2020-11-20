# Will create a Kind cluster with one control-plane node and one worker node by default.
function __usage() {
  echo "usage: apps [-c] [-w] [-i] [-h]"
  echo "  -c number of controller nodes"
  echo "  -w number of worker nodes"
  echo "  -i container image to use for booting the cluster nodes"
  echo "  -h show this usage text"
}

kind-up() {
  NUM_CONTROLLER="1"
  NUM_WORKER="1"
  KIND_CLUSTER_NODE_IMAGE="kindest/node:v1.18.6@sha256:b9f76dd2d7479edcfad9b4f636077c606e1033a2faf54a8e1dee6509794ce87d"

  while getopts ":c:w:i:h" opt; do
    case $opt in
      c)  NUM_CONTROLLER=${OPTARG};;
      w)  NUM_WORKER=${OPTARG};;
      i)  KIND_CLUSTER_NODE_IMAGE=${OPTARG};;
      h)  __usage; return;;
      \?) echo "Invalid option -$OPTARG, run with -h for help" >&2; return;;
    esac
  done

  ! read -r -d '' KIND_CLUSTER_CONF <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
nodes:
$(if [[ ${NUM_CONTROLLER} -ge 1 ]]; then
  yes "- role: control-plane" | head -n ${NUM_CONTROLLER}
else
  echo "- role: control-plane"
fi)
$(if [[ ${NUM_WORKER} -gt 0 ]]; then
  yes "- role: worker" | head -n ${NUM_WORKER}
fi)
EOF

  kind create cluster \
    --image "${KIND_CLUSTER_NODE_IMAGE}" \
    --config=- <<<"${KIND_CLUSTER_CONF}"
}

kind-destroy-all() {
    kind delete clusters --all
}
