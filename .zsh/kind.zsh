declare -g NUM_CONTROLLER=${1:-1}
declare -g NUM_WORKER=${2:-2}
declare -g KIND_CLUSTER_NODE_IMAGE=${3:-"kindest/node:v1.18.6@sha256:b9f76dd2d7479edcfad9b4f636077c606e1033a2faf54a8e1dee6509794ce87d"}
declare -g KIND_CLUSTER_CONF=""

kind-up() {
  NUM_CONTROLLER=${1:-"${NUM_CONTROLLER}"}
  NUM_WORKER=${2:-"${NUM_WORKER}"}
  KIND_CLUSTER_NODE_IMAGE=${3:-"${KIND_CLUSTER_NODE_IMAGE}"}

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
