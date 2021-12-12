# Will create a Kind cluster with one control-plane node and one worker node by default.
function __usage() {
  echo "usage: apps [-c] [-w] [-i] [-h]"
  echo "  -c number of controller nodes"
  echo "  -w number of worker nodes"
  echo "  -i container image to use for booting the cluster nodes"
  echo "  -h show this usage text"
}

# podman
# ------------------------------
# See: https://github.com/kubernetes-sigs/kind/issues/2445#issuecomment-984153923
#
# podman machine init --cpus 4 --memory 10240 --disk-size 50
# podman system connection default podman-machine-default-root
# ...start Kind cluster...
# sed -i '' -E 's#(https:\/\/:)([0-9]{5})#https:\/\/localhost:\2#g' ~/.kube/config

kind-fix-kubeconfig() {
  kind export kubeconfig
  # fix the server address for the Kind cluster
  sed -i '' -E 's#(https:\/\/:)([0-9]{5})#https:\/\/localhost:\2#g' ~/.kube/config
}

kind-up() {
  NUM_CONTROLLER="1"
  NUM_WORKER="1"
  KIND_CLUSTER_NODE_IMAGE="docker.io/kindest/node:v1.21.1@sha256:f08bcc2d38416fa58b9857a1000dd69062b0c3024dcbd696373ea026abe38bbc"

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
  apiServerAddress: "0.0.0.0"
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

  kind-fix-kubeconfig
}

kind-destroy-all() {
    kind delete clusters --all
}
