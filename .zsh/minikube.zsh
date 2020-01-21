declare -g MINIKUBE_PROFILE='localdev'
# https://github.com/kubernetes/kubernetes/releases (successfully tested used v1.14.7)
# Check NewestKubernetesVersion & OldestKubernetesVersion in constants.go
# https://github.com/kubernetes/minikube/blob/master/pkg/minikube/constants/constants.go
#declare -g MINIKUBE_K8S_VERSION='v1.14.7'
declare -g MINIKUBE_K8S_VERSION='v1.16.5'
declare -g MINIKUBE_CPUS='4'
declare -g MINIKUBE_MEMORY='6144'
declare -g MINIKUBE_DISKSIZE='100g'
declare -g MINIKUBE_CLUSTER_DOMAIN='cluster.local'
# https://minikube.sigs.k8s.io/docs/reference/drivers/hyperkit/
declare -g MINIKUBE_VMDRIVER='hyperkit'
# https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/#overview
# https://github.com/kubernetes/kubernetes/issues/27140
# https://stupefied-goodall-e282f7.netlify.com/contributors/design-proposals/node/troubleshoot-running-pods/
# from 1.16 (Alpha)
#declare -g MINIKUBE_FEATURE_GATES='EphemeralContainers=true'
declare -g MINIKUBE_FEATURE_GATES=''
declare -g KUBELET_MAX_PODS='150'

# https://github.com/cilium/cilium/releases
declare -g CILIUM_VERSION='1.6.3'

# https://github.com/projectcalico/calico/releases
declare -g CALICO_VERSION='3.10'

# https://github.com/kubernetes/minikube/issues/3036
declare -g NAMESERVER_PATCH_IP='1.1.1.1'

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

minikube-up() {
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
    --extra-config       "kubelet.container-runtime=remote" \
    --extra-config       "kubelet.container-runtime-endpoint=/var/run/crio/crio.sock" \
    --extra-config       "kubelet.image-service-endpoint=/var/run/crio/crio.sock" \
    --extra-config       "kubelet.max-pods=${KUBELET_MAX_PODS}" \
    --network-plugin     "cni" \
    --bootstrapper       "kubeadm" \
    --enable-default-cni \
    --disable-driver-mounts

  __minikube-etc-resolv-patch
  __minikube-addon-registry
#  __minikube-network-calico
#  __minikube-service-mesh-istio-calico
  ##__minikube-network-cilium
  ##__minikube-service-mesh-istio-cilium

  echo "✅  minikube successfully started"
}

minikube-stop() {
  __minikube-check-dependencies || return 1

  minikube stop
}

minikube-destroy() {
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
  brew list yq &>/dev/null || brew install yq
  /bin/bash <(curl -fsSL https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/patch-coredns.sh)

  # create DaemonSet to patch /etc/hosts on the Minikube Host VM
  kubectl create -f https://raw.githubusercontent.com/kameshsampath/minikube-helpers/master/registry/node-etc-hosts-update.yaml
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'app=registry-aliases-hosts-update'
}

__minikube-network-calico() {
  # https://cloud.google.com/blog/products/gcp/network-policy-support-for-kubernetes-with-calico
  # https://cloud.google.com/kubernetes-engine/docs/how-to/network-policy#creating_a_network_policy
  # https://docs.projectcalico.org/v3.10/introduction/deployments
  # http://info.tigera.io/rs/805-GFH-732/images/ProjectCalico-Datasheet.pdf
  echo "⌛  setting up Calico network"
  kubectl create -f "https://docs.projectcalico.org/v${CALICO_VERSION}/manifests/calico.yaml" || return 1
  sleep 10
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'k8s-app=calico-node'

  minikube ssh -- 'sudo systemctl restart crio'

  kubectl -n kube-system delete pod -l 'k8s-app=calico-node'
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'k8s-app=calico-node'

  kubectl -n kube-system delete pod -l 'k8s-app=kube-dns'
  kubectl -n kube-system delete pod -l 'kubernetes.io/minikube-addons=registry'
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'k8s-app=kube-dns'
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'kubernetes.io/minikube-addons=registry'
}

__minikube-service-mesh-istio-calico() {
  # FYI: GKE setup https://istio.io/docs/setup/additional-setup/cni/#gke-setup
  # Helm Chart options: https://istio.io/docs/reference/config/installation-options/#sidecarinjectorwebhook-options
  # Helm Chart CNI options: https://istio.io/docs/setup/additional-setup/cni/#helm-chart-parameters
  export ISTIO_VERSION='1.3.3'
  export ISTIO_NAMESPACE='istio-system'
  export ISTIO_HOME="$HOME/bin/istio-${ISTIO_VERSION}"
  export PATH="$PATH:${ISTIO_HOME}/bin"

  ###### download the Istio release
  #####mkdir -p $HOME/bin
  #####pushd $HOME/bin
  #####  curl -fsSL https://git.io/getLatestIstio | sh -
  #####popd

  echo "⌛  installing Istio ${ISTIO_VERSION}"
  # install Istio CNI plugin
  helm template \
    --namespace 'kube-system' \
    --set 'logLevel=info' \
    --set 'excludeNamespaces={"istio-system,kube-system"}' \
    istio-cni \
    ${ISTIO_HOME}/install/kubernetes/helm/istio-cni | kubectl create -f -
  kubectl -n 'kube-system' wait pod \
    -l 'k8s-app=istio-cni-node' \
    --for condition=Ready \
    --timeout 600s
  # restart cri-o so the Istio CNI plugin is loaded
  minikube ssh -- 'sudo systemctl restart crio'
  sleep 5

  # create Istio namespace
  kubectl create namespace "${ISTIO_NAMESPACE}"

  # install Istio CRDs
  helm template \
    --namespace "${ISTIO_NAMESPACE}" \
    istio-init \
    ${ISTIO_HOME}/install/kubernetes/helm/istio-init | kubectl create -f -
  echo -n "⌛ waiting for CRDs to be ready..."
  while [ "$(kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l | tr -d ' ')" != "23" ]; do
    echo -n "."
    sleep 5
  done
  echo ""
  sleep 60

  # install Istio
  helm template \
    --validate \
    --namespace "${ISTIO_NAMESPACE}" \
    --set 'istio_cni.enabled=true' \
    --set 'sidecarInjectorWebhook.enabled=true' \
    --set 'sidecarInjectorWebhook.replicaCount=1' \
    --set 'sidecarInjectorWebhook.rewriteAppHTTPProbe=false' \
    --set 'global.k8sIngress.enabled=true' \
    --set 'global.mtls.enabled=true' \
    --set 'global.controlPlaneSecurityEnabled=false' \
    --set 'kiali.enabled=true' \
    --set 'kiali.ingress.enabled=true' \
    --set 'kiali.createDemoSecret=true' \
    --set 'prometheus.enabled=true' \
    --set 'prometheus.ingress.enabled=true' \
    --set 'grafana.enabled=true' \
    --set 'grafana.ingress.enabled=true' \
    --set 'istiocoredns.enabled=true' \
    --set 'tracing.enabled=true' \
    --set 'gateways.enabled=true' \
    --set 'gateways.istio-ingressgateway.enabled=true' \
    --set 'gateways.istio-ingressgateway.autoscaleEnabled=true' \
    --set 'gateways.istio-egressgateway.enabled=true' \
    --set 'gateways.istio-egressgateway.autoscaleEnabled=true' \
    --set 'pilot.autoscaleEnabled=true' \
    --set 'mixer.policy.autoscaleEnabled=true' \
    --set 'mixer.telemetry.autoscaleEnabled=true' \
    istio \
    ${ISTIO_HOME}/install/kubernetes/helm/istio | kubectl create -f -
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

__minikube-network-cilium() {
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
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'k8s-app=cilium'

  minikube ssh -- 'sudo systemctl restart crio'

  kubectl -n kube-system delete pod -l 'k8s-app=cilium'
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'k8s-app=cilium'

  kubectl -n kube-system delete pod -l 'k8s-app=kube-dns'
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'k8s-app=kube-dns'

  kubectl -n kube-system delete pod -l 'kubernetes.io/minikube-addons=registry'
  kubectl -n kube-system wait --timeout 600s --for condition=Ready pod -l 'kubernetes.io/minikube-addons=registry'

  kubectl -n kube-system exec \
    $(kubectl -n kube-system get pod -l 'k8s-app=cilium' -ojsonpath='{.items[0].metadata.name}') \
    -- cilium endpoint list
}

__minikube-service-mesh-istio-cilium() {
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
  kubectl -n istio-system wait --timeout 600s --for condition=Available deployment -l 'release=istio'
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

__minikube-install-operators() {
  curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/0.12.0/install.sh | bash -s 0.12.0
  kubectl -n olm wait --timeout 600s --for condition=Ready pod -l 'app=packageserver'

  kubectl create -f https://operatorhub.io/install/prometheus.yaml
  kubectl create -f https://operatorhub.io/install/grafana-operator.yaml
  # kubectl create -f https://operatorhub.io/install/istio.yaml
  # kubectl create -f https://operatorhub.io/install/rook-ceph.yaml
  # kubectl create -f https://operatorhub.io/install/vault.yaml
  # kubectl create -f https://operatorhub.io/install/metering-upstream.yaml


  kubectl get csv -n my-grafana-operator
  kubectl get csv -n my-prometheus
  # kubectl get csv -n operators
  # kubectl get csv -n my-rook-ceph
  # kubectl get csv -n my-vault
  # kubectl get csv -n my-metering-upstream
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
