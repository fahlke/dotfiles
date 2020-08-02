declare -g MINIKUBE_PROFILE='minikube'
# https://github.com/kubernetes/kubernetes/releases (successfully tested used v1.16.11)
# Check NewestKubernetesVersion & OldestKubernetesVersion in constants.go
# https://github.com/kubernetes/minikube/blob/master/pkg/minikube/constants/constants.go
declare -g MINIKUBE_K8S_VERSION='v1.16.11'
declare -g MINIKUBE_CPUS='6'
declare -g MINIKUBE_MEMORY='10240'
declare -g MINIKUBE_DISKSIZE='100g'
declare -g MINIKUBE_CLUSTER_DOMAIN='cluster.local'
# https://minikube.sigs.k8s.io/docs/reference/drivers/hyperkit/
declare -g MINIKUBE_VMDRIVER='hyperkit'
# https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#overview
# https://github.com/kubernetes/kubernetes/issues/27140
# https://stupefied-goodall-e282f7.netlify.com/contributors/design-proposals/node/troubleshoot-running-pods/
# from 1.16 (Alpha)
declare -g MINIKUBE_FEATURE_GATES='EphemeralContainers=true,HPAScaleToZero=true'
# https://v1-16.docs.kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#which-plugins-are-enabled-by-default
# Configured are the defaults and additionally the Alpha feature "PodPreset Admission Controller Plugin"
declare -g APISERVER_ADMISSION_CONTROLLER="NamespaceLifecycle,LimitRanger,ServiceAccount,TaintNodesByCondition,Priority,DefaultTolerationSeconds,DefaultStorageClass,StorageObjectInUseProtection,PersistentVolumeClaimResize,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,RuntimeClass,ResourceQuota,PodPreset"
declare -g KUBELET_MAX_PODS='150'

declare -g POD_CIDR='10.4.0.0/19'

# https://github.com/cilium/cilium/releases
declare -g CILIUM_HELM_VERSION='1.8.0'
declare -g CILIUM_ENABLED='true'

# https://github.com/kubernetes/minikube/issues/3036
declare -g NAMESERVER_PATCH_IP='1.1.1.1'

__minikube-refresh-functions() {
  source $HOME/.zsh/minikube.zsh
}

__minikube-check-dependencies(){
  if [[ $(command -v brew >/dev/null; echo $?) -ne 0 ]]; then
    echo "brew command not found. Install Homebrew first (https://brew.sh/)."
    return 1
  fi

  brew cask list minikube &>/dev/null || brew cask install minikube

  if [[ "${MINIKUBE_VMDRIVER}" == "hyperkit" ]]; then
    brew list hyperkit &>/dev/null || brew install hyperkit
  fi

  minikube profile "${MINIKUBE_PROFILE}"
}

minikube-up-docker() {
  __minikube-refresh-functions || true
  __minikube-check-dependencies || return 1

  minikube start \
    --kubernetes-version "${MINIKUBE_K8S_VERSION}" \
    --cpus               "${MINIKUBE_CPUS}" \
    --memory             "${MINIKUBE_MEMORY}" \
    --disk-size          "${MINIKUBE_DISKSIZE}" \
    --dns-domain         "${MINIKUBE_CLUSTER_DOMAIN}" \
    --vm-driver          "${MINIKUBE_VMDRIVER}" \
    --feature-gates      "${MINIKUBE_FEATURE_GATES}" \
    --extra-config       "kubeadm.pod-network-cidr=${POD_CIDR}" \
    --extra-config       "kubelet.max-pods=${KUBELET_MAX_PODS}" \
    --extra-config       "kubelet.authentication-token-webhook=true" \
    --extra-config       "kubelet.authorization-mode=Webhook" \
    --extra-config       "scheduler.address=0.0.0.0" \
    --extra-config       "controller-manager.allocate-node-cidrs=true" \
    --extra-config       "controller-manager.address=0.0.0.0" \
    --extra-config       "apiserver.runtime-config=settings.k8s.io/v1alpha1=true" \
    --extra-config       "apiserver.enable-admission-plugins=${APISERVER_ADMISSION_CONTROLLER}" \
    --network-plugin     "cni" \
    --bootstrapper       "kubeadm" \
    --enable-default-cni \
    --disable-driver-mounts

  __minikube-etc-resolv-patch

  if [[ "${CILIUM_ENABLED}" == 'true' ]]; then
    echo "👉  installing 'Cilium' overlay network"
    __minikube-cilium-network-docker
    ##__minikube-cilium-service-mesh-istio
    echo "✅  cluster network set to 'Cilium (${CILIUM_HELM_VERSION})'"
  else
    echo "✅  cluster network set to 'minikube default'"
  fi

  __minikube-addon-registry

  echo "✅  minikube successfully started with docker runtime"
}


minikube-up-crio() {
  __minikube-refresh-functions || true
  __minikube-check-dependencies || return 1

  minikube start \
    --kubernetes-version "${MINIKUBE_K8S_VERSION}" \
    --cpus               "${MINIKUBE_CPUS}" \
    --memory             "${MINIKUBE_MEMORY}" \
    --disk-size          "${MINIKUBE_DISKSIZE}" \
    --dns-domain         "${MINIKUBE_CLUSTER_DOMAIN}" \
    --vm-driver          "${MINIKUBE_VMDRIVER}" \
    --feature-gates      "${MINIKUBE_FEATURE_GATES}" \
    --container-runtime  "crio" \
    --cri-socket         "/var/run/crio/crio.sock" \
    --extra-config       "kubeadm.pod-network-cidr=${POD_CIDR}" \
    --extra-config       "kubelet.container-runtime=remote" \
    --extra-config       "kubelet.container-runtime-endpoint=/var/run/crio/crio.sock" \
    --extra-config       "kubelet.image-service-endpoint=/var/run/crio/crio.sock" \
    --extra-config       "kubelet.max-pods=${KUBELET_MAX_PODS}" \
    --extra-config       "kubelet.authentication-token-webhook=true" \
    --extra-config       "kubelet.authorization-mode=Webhook" \
    --extra-config       "scheduler.address=0.0.0.0" \
    --extra-config       "controller-manager.allocate-node-cidrs=true" \
    --extra-config       "controller-manager.address=0.0.0.0" \
    --extra-config       "apiserver.enable-admission-plugins=${APISERVER_ADMISSION_CONTROLLER}" \
    --network-plugin     "cni" \
    --bootstrapper       "kubeadm" \
    --enable-default-cni \
    --disable-driver-mounts

  __minikube-etc-resolv-patch

  if [[ "${CILIUM_ENABLED}" == 'true' ]]; then
    echo "👉  installing 'Cilium' overlay network"
    ##__minikube-cilium-network-crio
    ##__minikube-cilium-service-mesh-istio
    echo "✅  cluster network set to 'Cilium (${CILIUM_HELM_VERSION})'"
  else
    echo "✅  cluster network set to 'minikube default'"
  fi

  __minikube-addon-registry

  echo "✅  minikube successfully started with cri-o runtime"
}

minikube-stop() {
  __minikube-refresh-functions || true
  __minikube-check-dependencies || return 1

  minikube stop
}

minikube-destroy() {
  __minikube-refresh-functions || true
  __minikube-check-dependencies || return 1

  minikube delete
  #rm -f ${PATCH_MARKER_PATH}
}

__minikube-addon-registry() {
  echo "👉  patching minikube registry addon"
  # add insecure container registry to local Docker installation
  brew list ipcalc &>/dev/null || brew install ipcalc
  CIDR=$(ipcalc -n $(minikube ip) | grep Network | tr -s ' ' | cut -d ' ' -f2)
  mkdir -p $HOME/.docker
  tee $HOME/.docker/daemon.json >/dev/null <<EOF
{
  "debug" : true,
  "experimental" : false,
  "insecure-registries": ["${CIDR}"]
}
EOF

  # restart local Docker
  osascript -e 'quit app "Docker"' && open -a Docker

  minikube addons enable 'registry'

  # https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/registry-aliases-config.yaml
  kubectl create -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: registry-aliases
  namespace: kube-system
data:
  registrySvc: registry.kube-system.svc.cluster.local
  registryAliases: >-
    registry.local
EOF

  # patch CoreDNS
  kubectl create -f https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/registry-aliases-sa.yaml
  kubectl create -f https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/registry-aliases-sa-crb.yaml
  kubectl create -f https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/patch-coredns-job.yaml

  # create DaemonSet to patch /etc/hosts on the Minikube Host VM
  kubectl create -f https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/node-etc-hosts-update.yaml
  kubectl wait \
    --for       'condition=Ready' \
    --timeout   '5m0s' \
    --namespace 'kube-system' \
    pod -l 'app=registry-aliases-hosts-update'

  # remove CoreDNS patch job
  kubectl delete -f https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/patch-coredns-job.yaml
}

__minikube-etc-resolv-patch() {
  # https://github.com/kubernetes/minikube/issues/3036
  echo "👉  patching nameservers in /etc/resolv.conf on minikube (see: https://github.com/kubernetes/minikube/issues/3036)"
  minikube ssh -- \
    "sudo sed -i 's/#DNS=.*/DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001/' /etc/systemd/resolved.conf;" \
    "sudo sed -i 's/#FallbackDNS=.*/FallbackDNS=8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844/' /etc/systemd/resolved.conf;" \
    "sudo systemctl restart systemd-resolved;"
  sleep 3
  echo "✅  done patching nameservers"

}

__minikube-cilium-network-docker() {
  # https://docs.cilium.io/en/latest/kubernetes/configuration
  # https://docs.cilium.io/en/latest/configuration/metrics/
  # https://docs.cilium.io/en/latest/gettingstarted/istio/
  minikube ssh -- "grep -qs '/sys/fs/bpf' /proc/mounts || sudo mount bpffs -t bpf /sys/fs/bpf" || return 1

  # https://docs.cilium.io/en/v1.8/gettingstarted/encryption/
  kubectl create -n kube-system secret generic cilium-ipsec-keys \
    --from-literal=keys="3 rfc4106(gcm(aes)) $(echo $(dd if=/dev/urandom count=20 bs=1 2> /dev/null| xxd -p -c 64)) 128"

  helm repo add cilium https://helm.cilium.io/
  helm repo update

  # https://github.com/cilium/cilium/blob/v1.8.0/install/kubernetes/cilium/values.yaml
  helm install cilium cilium/cilium \
    --atomic \
    --timeout '15m0s' \
    --version "${CILIUM_HELM_VERSION}" \
    --namespace 'kube-system' \
    --set 'preflight.enabled=true' \
    --set 'global.psp.enabled=true' \
    --set 'global.etcd.enabled=true' \
    --set 'global.etcd.managed=true' \
    --set "global.etcd.clusterDomain=${MINIKUBE_CLUSTER_DOMAIN}" \
    --set 'global.etcd.clusterSize=1' \
    --set 'global.prometheus.enabled=true' \
    --set 'global.prometheus.serviceMonitor.enabled=true' \
    --set 'global.operatorPrometheus.enabled=true' \
    --set 'global.hubble.enabled=true' \
    --set 'global.hubble.relay.enabled=true' \
    --set 'global.hubble.ui.enabled=true' \
    --set 'global.hubble.metrics.enabled={dns:query;ignoreAAAA,drop,tcp,flow,port-distribution,icmp,http}' \
    --set 'global.hubble.metrics.serviceMonitor.enabled=true' \
    --set 'global.hubble.listenAddress=:4244' \
    --set 'global.bpf.waitForMount=true' \
    --set 'global.encryption.enabled=false' \
    --set 'global.encryption.nodeEncryption=false' \
    --set 'global.nodeinit.enabled=true' \
    --set 'global.containerRuntime.integration=docker'
}

__minikube-network-cilium-crio() {
  # https://docs.cilium.io/en/latest/kubernetes/configuration
  # https://docs.cilium.io/en/latest/configuration/metrics/
  # https://docs.cilium.io/en/latest/gettingstarted/istio/
  minikube ssh -- "grep -qs '/sys/fs/bpf' /proc/mounts || sudo mount bpffs -t bpf /sys/fs/bpf" || return 1

  mkdir -p /tmp/cilium-${CILIUM_VERSION}
  curl -fsSL https://github.com/cilium/cilium/archive/v${CILIUM_VERSION}.tar.gz -o /tmp/cilium-${CILIUM_VERSION}.tar.gz || return 1
  tar xzf /tmp/cilium-${CILIUM_VERSION}.tar.gz -C /tmp
  pushd /tmp/cilium-${CILIUM_VERSION}/install/kubernetes
    helm template cilium \
      --namespace kube-system \
      --set global.containerRuntime.integration=crio \
      --set global.prometheus.enabled=true \
      --set global.prometheus.serviceMonitor.enabled=false \
      --set global.bpf.waitForMount=true \
      > cilium.yaml
    kubectl create -f cilium.yaml
  popd
  rm -rf /tmp/cilium-${CILIUM_VERSION}
  kubectl wait \
    --for       condition=Ready \
    --timeout   600s \
    --namespace kube-system \
    pod -l 'k8s-app=cilium'

  minikube ssh -- 'sudo systemctl restart crio'

  kubectl -n kube-system delete pod -l 'k8s-app=cilium'
  kubectl wait \
    --for       condition=Ready \
    --timeout   600s \
    --namespace kube-system \
    pod -l 'k8s-app=cilium'

  kubectl -n kube-system delete pod -l 'k8s-app=kube-dns'
  kubectl wait \
    --for       condition=Ready \
    --timeout   600s \
    --namespace kube-system \
    pod -l 'k8s-app=kube-dns'

  kubectl -n kube-system delete pod -l 'kubernetes.io/minikube-addons=registry'
  kubectl wait \
    --for       condition=Ready \
    --timeout   600s \
    --namespace kube-system \
    pod -l 'kubernetes.io/minikube-addons=registry'

  kubectl -n kube-system exec \
    $(kubectl -n kube-system get pod -l 'k8s-app=cilium' -ojsonpath='{.items[0].metadata.name}') \
    -- cilium endpoint list
}

__minikube-cilium-service-mesh-istio() {
  # https://docs.cilium.io/en/v1.6/gettingstarted/istio/
  export ISTIO_VERSION=1.2.5
  curl -fsSL https://git.io/getLatestIstio | sh -
  export ISTIO_HOME=$(pwd)/istio-${ISTIO_VERSION}
  export PATH="$PATH:${ISTIO_HOME}/bin"

  cp -r ${ISTIO_HOME}/install/kubernetes/helm/istio /tmp/istio-cilium-helm

  curl -fsSL https://raw.githubusercontent.com/cilium/cilium/v1.6/examples/kubernetes-istio/cilium-pilot.awk > /tmp/cilium-pilot.awk
  awk -f /tmp/cilium-pilot.awk \
    < ${ISTIO_HOME}/install/kubernetes/helm/istio/charts/pilot/templates/deployment.yaml \
    > /tmp/istio-cilium-helm/charts/pilot/templates/deployment.yaml

  sed -e 's,#interceptionMode: .*,interceptionMode: TPROXY,' \
    < ${ISTIO_HOME}/install/kubernetes/helm/istio/templates/configmap.yaml \
    > /tmp/istio-cilium-helm/templates/configmap.yaml

  curl -fsSL https://raw.githubusercontent.com/cilium/cilium/v1.6/examples/kubernetes-istio/cilium-kube-inject.awk > /tmp/cilium-kube-inject.awk
  awk -f /tmp/cilium-kube-inject.awk \
    < ${ISTIO_HOME}/install/kubernetes/helm/istio/files/injection-template.yaml \
    > /tmp/istio-cilium-helm/files/injection-template.yaml

  kubectl create namespace istio-system
  helm template istio-init ${ISTIO_HOME}/install/kubernetes/helm/istio-init \
    --namespace istio-system \
    > /tmp/istio-init.yaml
  kubectl create -f /tmp/istio-init.yaml
  echo -n "⌛ waiting for CRDs to be ready..."
  while [ "$(kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l | tr -d ' ')" != "23" ]; do
    echo -n "."
    sleep 5
  done
  echo ""

  # added validate option so the templating will check against the configured cluster
  helm template istio /tmp/istio-cilium-helm \
    --validate \
    --namespace istio-system \
    --set pilot.image=docker.io/cilium/istio_pilot:${ISTIO_VERSION} \
    --set sidecarInjectorWebhook.enabled=false \
    --set global.controlPlaneSecurityEnabled=true \
    --set global.mtls.enabled=true \
    --set global.proxy.image=docker.io/cilium/istio_proxy:${ISTIO_VERSION} \
    --set ingress.enabled=false \
    --set egressgateway.enabled=false \
    > /tmp/istio-cilium.yaml

  kubectl create -f /tmp/istio-cilium.yaml
  kubectl wait \
    --for       condition=Available \
    --timeout   600s \
    --namespace istio-system \
    deployment -l 'release=istio'
}

__minikube-ingress-traefik() {
  minikube tunnel --cleanup
  minikube tunnel
  git clone https://github.com/containous/traefik-helm-chart.git /tmp/traefik
  helm --debug install \
    --atomic \
    --timeout 1m0s \
    --namespace kube-system \
    traefik \
    /tmp/traefik

  open "http://$(minikube ip):$(kubectl -n kube-system get svc traefik -ojsonpath='{ .spec.ports[0].nodePort }')/dashboard/#/"
}

#### # minikube registry example
#### # https://minikube.sigs.k8s.io/docs/tasks/docker_registry/
#### docker build --label "registry=minikube" --tag $(minikube ip):5000/k8stester:v1.0.0 .
#### docker push $(minikube ip):5000/k8stester:v1.0.0
#### docker rmi -f $(docker images -q --filter label=registry=minikube)
#### docker image prune -f --filter label=stage=intermediate
#### 
#### minikube ssh -- 'wget -q registry.local:80/v2/_catalog -O -'
#### kubectl run alpine --image alpine --restart=Never -- /bin/sh -c 'wget -q registry.local:80/v2/_catalog -O -'
#### 
#### kubectl run k8stester --image registry.local:80/k8stester:v1.0.0 --restart=Never
#### kubectl delete pod k8stester


#kubectl cluster-info dump | grep -m 1 service-cluster-ip-range
#kubectl cluster-info dump | grep -m 1 cluster-cidr