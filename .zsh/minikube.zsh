# Change the variables below as desired
declare -g MINIKUBE_K8S_VERSION='v1.14.4'
declare -g MINIKUBE_CPUS='2'
declare -g MINIKUBE_MEMORY='3072'
declare -g MINIKUBE_CLUSTER_DOMAIN='cluster.local'
declare -g MINIKUBE_VMDRIVER='virtualbox'
# check https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#overview
# eg: https://stupefied-goodall-e282f7.netlify.com/contributors/design-proposals/node/troubleshoot-running-pods/
#declare -g MINIKUBE_FEATURE_GATES='DebugContainers=true'
declare -g MINIKUBE_FEATURE_GATES=''
# run `minikube addons list`to get a list of available addons
declare -g MINIKUBE_ADDONS=('metrics-server' 'efk' 'registry')

__minikube-check-dependencies(){
  if [[ $(command -v minikube >/dev/null; echo $?) -ne 0 ]]; then
    echo "minikube command not found. Run \`minikube-prepare\` to install it."
    return 1
  fi
}

minikube-prepare() {
  if [[ $(command -v brew >/dev/null; echo $?) -ne 0 ]]; then
    echo "brew command not found. Install Homebrew first (https://brew.sh/)."
    return 1
  fi

  brew cask list minikube &>/dev/null || brew cask install minikube
}

minikube-start() {
  __minikube-check-dependencies || return 1

  minikube start \
    --kubernetes-version "${MINIKUBE_K8S_VERSION}" \
    --cpus               "${MINIKUBE_CPUS}" \
    --memory             "${MINIKUBE_MEMORY}" \
    --dns-domain         "${MINIKUBE_CLUSTER_DOMAIN}" \
    --vm-driver          "${MINIKUBE_VMDRIVER}" \
    --feature-gates      "${MINIKUBE_FEATURE_GATES}" \
    --container-runtime  "crio" \
    --cri-socket         "/var/run/crio/crio.sock" \
    --extra-config       "kubelet.container-runtime=remote" \
    --extra-config       "kubelet.container-runtime-endpoint=unix:///var/run/crio/crio.sock" \
    --extra-config       "kubelet.image-service-endpoint=unix:///var/run/crio/crio.sock" \
    --network-plugin     "cni" \
    --enable-default-cni \
    --disable-driver-mounts \
    --cache-images
}

__minikube-addons-helper(){
  __minikube-check-dependencies || return 1

  if [[ ! -z $1 && ( "$1" == "enable" || "$1" == "disable" ) ]]; then
    for ADDON in ${MINIKUBE_ADDONS[@]}; do
      minikube addons $1 "${ADDON}"
    done
  else
    return 1
  fi
}

minikube-addons-enable() {
  __minikube-addons-helper 'enable'
}

minikube-addons-disable() {
  __minikube-addons-helper 'disable'
}

minikube-addons-list-enabled() {
  __minikube-check-dependencies || return 1

  minikube addons list | grep enabled
}

minikube-stop() {
  __minikube-check-dependencies || return 1

  minikube stop
}

minikube-destroy() {
  __minikube-check-dependencies || return 1

  minikube delete
}