# Module 06 (Certified Kubernetes Administrator — CKA): Bare-Metal `kubeadm` Cluster, Zero-Trust NetworkPolicies & Chaos Recovery Runbook

**Required Notice:** Copyright (c) 2026 Adam Dryden (`Phlotonic`) — Dual-Licensed under PolyForm Noncommercial 1.0.0 & Commercial License.

## 1. Executive Architecture Summary
This module bootstraps a production-grade, three-node Kubernetes v1.31 cluster (`k8s-cp-01`, `k8s-worker-01`, `k8s-worker-02`) on bare Linux VMs using **`kubeadm`** and **`containerd`** configured with `SystemdCgroup = true`. Cluster networking is powered by **Calico CNI** to enforce zero-trust **`NetworkPolicy`** micro-segmentation (`isolate-backend-namespace`), restricting TCP port 80 ingress on the `backend` namespace exclusively to pods labeled `tier: frontend`, backed by a 5Gi `PersistentVolume` and bare-metal **NGINX Ingress Controller**. Accompanied by a comprehensive **CKA Break/Fix Runbook**, the module documents live diagnosis and recovery procedures for control-plane static pod failures (`crictl`), broken `kubelet` systemd units (`status=203/EXEC`), and expired cluster PKI certificates (`kubeadm certs renew all`).

---

## 2. Cluster & Zero-Trust Micro-Segmentation Topology

```mermaid
flowchart LR
    Client["External HTTPS/HTTP Traffic<br/>(api.quanumis.lab)"] --> Ingress["NGINX Ingress Controller"]

    subgraph K8s["3-Node Bare-VM kubeadm v1.31 Cluster (k8s-cp-01 + 2 Workers)"]
        Ingress
        subgraph NS_Front["Namespace: frontend (tier: frontend)"]
            FrontPod["Frontend Workload Pods"]
        end
        subgraph NS_Back["Namespace: backend (tier: backend)"]
            NetPol["NetworkPolicy: isolate-backend-namespace<br/>(Allow TCP 80 ONLY from tier: frontend)"]
            BackSvc["Service: backend-svc (Port 80)"] --> BackPod["Deployment: backend-api<br/>(2 Replicas, nginx:1.27-alpine)"]
            BackPod --> PVC["PVC: pvc-app-data (5Gi)"] --> PV["PersistentVolume: pv-app-data"]
        end
    end

    FrontPod -- "Permitted by Calico CNI" --> NetPol --> BackSvc
```

---

## 3. Component & Configuration Specification

| Artifact | Functional Role | Production Engineering Rationale |
| :--- | :--- | :--- |
| [`bootstrap-kubeadm.sh`](./bootstrap-kubeadm.sh) | Node preparation and cluster bootstrap script configuring kernel modules (`overlay`, `br_netfilter`), `containerd` (`SystemdCgroup = true`), `kubeadm init`, Calico CNI, and NGINX Ingress. | Aligns the container runtime and `kubelet` on the `systemd` cgroup v2 driver to prevent resource accounting splits and node instability under load. |
| [`cluster-workloads.yaml`](./cluster-workloads.yaml) | Declarative manifests for namespaces, 5Gi PV/PVC storage, 2-replica deployment, Service, Ingress, and zero-trust `NetworkPolicy`. | Replaces Kubernetes' default flat pod-to-pod network behavior with explicit namespace-to-namespace ingress whitelisting. |
| [`CKA-Break-Fix-Runbook.md`](./CKA-Break-Fix-Runbook.md) | Incident recovery runbook covering API server static pod corruption, `kubelet` systemd misconfiguration, and PKI certificate expiration. | Provides deterministic out-of-band recovery commands (`crictl`, `journalctl`, `kubeadm certs`) when the Kubernetes API server itself is unreachable. |

---

## 4. Key Architectural Design Decisions

1. **How are control-plane container failures diagnosed when `kube-apiserver` is down and `kubectl` returns `connection refused`?**
   - Because `kubectl` requires a functioning API server, diagnosis must occur directly against the container runtime socket on `k8s-cp-01` using `sudo crictl ps -a | grep kube-apiserver` and `sudo crictl logs <CONTAINER_ID>`, followed by correcting `/etc/kubernetes/manifests/kube-apiserver.yaml`.
2. **Why is Calico CNI deployed instead of Flannel?**
   - Standard Flannel provides Layer 3 VXLAN overlay routing but does not include a network policy controller; applying a `NetworkPolicy` resource on a Flannel cluster results in no traffic filtering. Calico programs Linux kernel `iptables`/eBPF rules to actively enforce `isolate-backend-namespace`.
3. **Why must `SystemdCgroup = true` be set in `/etc/containerd/config.toml` prior to `kubeadm init`?**
   - `containerd config default` defaults to `SystemdCgroup = false` (`cgroupfs`), whereas `kubeadm` v1.31 configures `kubelet` to use the `systemd` cgroup driver. Matching both components on `systemd` prevents dual-cgroup-manager contention on Linux cgroups v2 hosts.

---

## 5. Deployment & Verification Runbook

```powershell
# 1. Render parameterized Kubernetes cluster configuration
powershell -NoProfile -ExecutionPolicy Bypass -File .\render-template.ps1

# 2. Execute automated CKA bootstrap, NetworkPolicy & chaos runbook validation
powershell -NoProfile -ExecutionPolicy Bypass -File .\validate-lab.ps1
```
