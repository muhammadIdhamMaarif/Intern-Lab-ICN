# Kyara Hybrid Multi-cloud Platform

```
Kyara-Infrastructure/
│ │ ├── otel-collector/
│ │ ├── falco/
│ │ ├── osquery/
│ │ └── teleport/
│ └── site.yml
├── modules/ # Reusable Terraform modules
│ ├── aws/
│ │ ├── vpc/
│ │ ├── cloudwan/
│ │ ├── eks/
│ │ ├── iam/
│ │ ├── security-baseline/
│ │ ├── network-services/ # ALB/NLB, WAF, GA, Route53
│ │ ├── data/
│ │ │ ├── aurora/
│ │ │ ├── rds/
│ │ │ ├── dynamodb/
│ │ │ ├── opensearch/
│ │ │ └── redshift/
│ │ ├── s3-lake/
│ │ ├── eventing-msk/
│ │ ├── backup/
│ │ └── observability/ # managed Grafana/Prometheus options
│ ├── azure/{vnet,aks,iam,firewall,private-link}
│ ├── gcp/{vpc,gke,iam,cloud-router}
│ └── cross/
│ ├── otel/
│ ├── grafana-stack/
│ ├── loki-tempo/
│ ├── vault/
│ ├── argocd/
│ ├── istio/
│ ├── cert-manager/
│ ├── external-dns/
│ ├── backstage/
│ ├── crossplane/
│ ├── teleport/
│ └── finops/
├── platform-api/ # Crossplane compositions/XRDs
│ ├── compositions/
│ ├── claims/
│ └── provider-configs/
├── kubernetes/ # Cluster-layer manifests (GitOps targets)
│ ├── clusters/
│ │ ├── prod-us-east-1/
│ │ │ ├── kustomization.yaml
│ │ │ ├── namespaces/
│ │ │ ├── infra-addons/ # cilium, karpenter, cert-manager, external-dns
│ │ │ └── mesh-istio/
│ │ └── prod-eu-west-1/...
│ ├── argocd/
│ │ ├── apps-of-apps/
│ │ └── projects/
│ ├── policies/ # Kyverno/Gatekeeper CRs
│ └── tenants/ # Team spaces (RBAC, quotas)
├── apps/ # App golden paths & examples
│ ├── templates/ # Helm charts for services/batch/cron/jobs
│ ├── examples/ # Sample services with OTel, Istio, HPA, PDB
│ └── charts/
├── observability/ # Dashboards-as-code, alerting rules
│ ├── grafana-dashboards/
│ ├── prometheus-rules/
│ ├── loki-queries/
│ └── k6-synthetic/
├── security/ # Supply-chain & policy bundles
│ ├── cosign/
│ ├── sbom/
│ ├── trivy-policies/
│ └── admission/
├── finops/ # CUR queries, Athena views, OpenCost setup
│ ├── athena/
│ ├── queries/
│ └── dashboards/
├── runbooks/ # Ops playbooks (markdown)
│ ├── dr-failover.md
│ ├── new-region.md
│ ├── incident-responder.md
│ └── rotate-keys.md
├── tests/
│ ├── terratest/ # Go tests for TF modules
│ ├── chaos/ # Litmus experiments
│ ├── policy/ # OPA/Kyverno unit tests
│ └── e2e/ # End-to-end smoke tests
└── toolchain/ # Dev containers, linting, hooks
├── devcontainer/
├── linters/
└── hooks/
```
