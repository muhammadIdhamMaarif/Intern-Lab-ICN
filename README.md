<div align="center">

# 🌐 Cloud Platform Infrastructure for Lab ICN Intern 🌐

### 🚀 **Hybrid Multi-Cloud | Zero-Trust | Everything as Code**

![Status](https://img.shields.io/badge/Status-On%20Development-orange?style=for-the-badge&logo=github)
![License](https://img.shields.io/badge/License-GPL%203.0-green?style=for-the-badge&logo=gnu)
![IaC](https://img.shields.io/badge/Infrastructure-As%20Code-4CAF50?style=for-the-badge&logo=terraform)
![Cloud](https://img.shields.io/badge/Multi--Cloud-AWS%20%7C%20Azure%20%7C%20GCP-0078D4?style=for-the-badge)
![CI/CD](https://img.shields.io/badge/CI/CD-GitHub%20Actions-black?style=for-the-badge&logo=githubactions)
![Observability](https://img.shields.io/badge/Observability-Grafana%20%7C%20Prometheus-FF6C37?style=for-the-badge&logo=grafana)

</div>

---

<h2 align="center">🛠️ On Development 🛠️</h2>
<p align="center">
  <i>Building the foundation of a resilient, zero-trust, hybrid multi-cloud platform.</i>
</p>


**Goals**

* **Hybrid & Multi‑Cloud**: Active/Active across two AWS regions (primary), with **Azure & GCP** landing zones. Seamless hybrid via Direct Connect/ExpressRoute/Interconnect, Cloud WAN/Aviatrix.
* **Separation of Concerns**: Networking, Platform, Data, Security, Observability, Developer Experience (DevEx), and Workloads are modular planes with clear contracts.
* **Everything as Code**: Terraform/Terragrunt, Crossplane (K8s‑native cloud APIs), Ansible, **Policies‑as‑Code** (OPA/Kyverno/Sentinel/Conftest), **Pipelines‑as‑Code** (GitHub Actions), **Dashboards‑as‑Code** (Grafana JSON, Prometheus rules), **FinOps‑as‑Code** (Infracost + policy gates).
* **Golden Paths**: Backstage templates + ArgoCD GitOps, paved‑road modules, secure defaults, org‑wide tagging/labels.
* **Zero‑Trust**: Identity‑aware proxies, SPIFFE/SPIRE, BeyondCorp‑style access, ZTNA for users and workloads.

**Non‑Functional Requirements (NFRs)**

* **RTO/RPO tiers**: Tier‑0 (RTO≤5m, RPO≈0), Tier‑1 (RTO≤30m, RPO≤5m), Tier‑2 (RTO≤4h, RPO≤1h), Tier‑3 (best‑effort).
* **Latency SLOs**: P95 global user < 200 ms; intra‑region service P95 < 10 ms; cross‑region replication P95 < 250 ms.
* **Change safety**: Progressive delivery, automated rollbacks, chaos & load tests in CI before prod.
* **Compliance**: CIS, ISO‑27001, SOC2, PCI‑DSS, HIPAA—mapped to controls and automated evidence.

---

## 1) Physical & Topology Overview

**On‑Premises** (two data centers + edge sites)

* **Compute**: VMware vSphere 8 clusters (vSAN stretched); **Nutanix AHV** islands for specific workloads.
* **Network**: Leaf‑spine with EVPN/VXLAN, dual ToR; **NSX‑T** overlay + distributed firewall; F5 BIG‑IP or NGINX Plus for L4–7.
* **Kubernetes**: **OpenShift** (primary) and **RKE2** (secondary) clusters; **MetalLB** for bare‑metal L2/L3 services; **Calico** or **Cilium** for CNI & NetworkPolicy.
* **Storage**: NetApp ONTAP (NAS/SAN), Pure FlashArray; object storage via MinIO (S3‑compatible) for local lakehouse cache.
* **Identity**: Active Directory (AD DS) with **Entra ID** sync (SCIM), conditional access.

**Cloud**

* **AWS** (primary): Multi‑account via Organizations/Control Tower, OUs: **Security**, **Shared‑Services**, **Platform**, **Data**, **Sandbox**, **Prod/Staging/Dev**.
* **Azure & GCP** : Parity landing zones (VNet/VPC; AKS/GKE; IAM/Entra/Workload Identity; equivalent data & observability stacks).

**Global Connectivity**

* **WAN**: Dual **Direct Connect** to each AWS region (hosted + dedicated), separate providers; **ExpressRoute**/**Interconnect** to Azure/GCP. BGP with diverse POPs, 10–100 Gbps links.
* **Cloud WAN / Aviatrix**: Global segmentation (Prod/Non‑Prod/Shared/Secure), hub‑and‑spoke VRFs, distributed firewalling, traffic engineering.
* **DNS**: Route 53 + on‑prem Infoblox; Private Hosted Zones with Route 53 **Resolver inbound/outbound** endpoints; **DNSSEC** and dedicated forwarding rules.
* **IPAM**: NetBox source of truth, IP allocations as code.


## 2) Networking & Security Fabric

* **Per‑Region Hub/Spoke**: TGW (AWS) + GWLB for inline **IDS/IPS** (Palo Alto/Check Point) and **DLP**; NVA scale sets in Azure; Cloud Router in GCP.
* **Egress**: Centralized **egress VPC/VNet** with NAT, TLS inspection (where legal), **egress proxy** (Squid/Envoy), outbound **Service Mesh EgressGateway** for app traffic allow‑list.
* **Ingress**: Multi‑ingress (Istio IngressGateway + NGINX Ingress + ALB Ingress Controller). **Global Accelerator** + Route 53 latency/health checks.
* **Micro‑Segmentation**: Cilium Network Policies & Hubble visibility; on‑prem NSX‑T DFW; optional Illumio for hybrid visibility.
* **Secrets & PKI**: Vault (Raft HA) with **Transit/Transform** engines (tokenization), **PKI** intermediate CAs; SPIFFE/SPIRE for workload IDs.
* **ZTNA**: Identity‑aware proxy (Pomerium/Cloudflare Access/Okta ASA), **Teleport** for bastionless SSH/Kube.
* **Data Protection**: BYOK/HYOK with KMS + CloudHSM; envelope encryption everywhere; customer‑managed keys per tenant.

---

## 3) Platform Layer (Kubernetes, Mesh, APIs)

* **Clusters**: EKS (Bottlerocket & managed node groups + Karpenter), AKS, GKE, **OpenShift** on‑prem. **Cluster API** to standardize lifecycle.
* **Add‑Ons**: Cilium (eBPF), Cluster Autoscaler, VPA, **Karpenter** consolidation, Kyverno/Gatekeeper, ExternalDNS, cert‑manager (ACME + private PKI), External Secrets Operator.
* **Service Mesh**: **Istio multi‑cluster/multi‑mesh** with east‑west gateways, **mTLS (STRICT)**, traffic policies (canary/A‑B, fault injection), global **virtualservices** layered with local override.
* **API Management**: Kong Gateway w/ OPA plugins (or Apigee/AGW), rate‑limits, JWT/OIDC, API monetization (if needed).
* **Platform APIs**: **Crossplane** to provision cloud resources via CRDs (RDS/Aurora/S3/Queues) with compositions; **Backstage** as the developer portal & service catalog.
* **Serverless**: Lambda/Step Functions/EventBridge (+ Azure Functions/Logic Apps; Cloud Functions/Workflows) for event‑driven glue & control‑planes.
* **Batch/HPC**: AWS Batch + Slurm on EKS (Karpenter spot), **FSx for Lustre** for scratch IO, Spot‑aware queueing.

---

## 4) Data Platform (OLTP, OLAP, Streaming, Governance)

* **OLTP**: **Aurora Global DB** (MySQL/Postgres) active/reader topology; **DynamoDB Global Tables** for low‑latency KV; **PostgreSQL on‑prem** for locality with CDC to cloud.
* **Search & Analytics**: OpenSearch for search/time‑series; **ClickHouse** for ultra‑fast OLAP; optional **Snowflake** for cross‑cloud warehousing.
* **Streaming**: **MSK (Kafka)** multi‑AZ w/ tiered storage + **Schema Registry**; Debezium CDC; optional **Pulsar** for geo‑replication; **EventBridge/SNS/SQS** for app events.
* **Lakehouse**: S3/ADLS/GCS with **Delta Lake / Apache Iceberg**, **Glue/Databricks/EMR** for ETL; **Trino/Athena** for interactive queries.
* **Caching**: ElastiCache Redis (w/ Redis Enterprise CRDT for active‑active when needed) + Memcached for simple patterns.
* **Data Governance**: **Lake Formation**, **Apache Ranger/Atlas**, **Unity Catalog** (if Databricks); classification with **Macie**/**DLP**; lineage via **OpenLineage/Marquez**.
* **ML Platform**: Feature store (**Feast**), tracking/registry (**MLflow**), pipelines (**Kubeflow**/SageMaker Pipelines), **KFServing/Seldon** or SageMaker for serving; drift detection & shadow deployments.

---

## 5) Observability, SIEM & SRE

* **Metrics**: Prometheus → **Thanos** (global view, object storage). Recording/alerting rules as code.
* **Logs**: **Loki** with S3 backend, tiered retention (hot/warm/cold), schema labels standardized via GEL/Vector.
* **Traces**: OpenTelemetry Collector → **Tempo**/**Jaeger**. Trace‑ID propagation enforced by gateways and SDKs.
* **eBPF**: **Pixie** for deep K8s telemetry, Cilium/Hubble flow; kernel‑level insights.
* **Synthetics/RUM**: k6 cloud or Grafana k6, blackbox exporter; real‑user monitoring for web/mobile.
* **SIEM/SOAR**: Splunk/Elastic/Sentinel; automated playbooks (Phantom/XSOAR/Logic Apps) for triage.
* **Incident**: Alertmanager → PagerDuty/Slack; Blameless postmortem templates; **Error Budgets** with Sloth/Nobl9.

---

## 6) Security, Identity & Compliance

* **Org Guardrails**: SCPs (deny wide‑open S3, restrict regions, enforce MFA), AWS Config rules, Azure Policies, GCP Org Policies.
* **IAM & SSO**: Entra ID/Okta → AWS IAM Identity Center (SAML/OIDC, SCIM).

  * **ABAC** via tags; **permission boundaries**; **session policies**; just‑in‑time elevation (break‑glass w/ MFA + short TTL).
* **PAM**: CyberArk for secrets/privileged sessions; Teleport for short‑lived certs & session recording.
* **Workload Identity**: SPIFFE/SPIRE issuance; IRSA/Workload Identity (AWS/GCP); Managed identities (Azure).
* **Supply Chain**: SLSA‑3 builds, **SBOM (Syft)**, vuln scan (Grype/Trivy), image signing **(Cosign)** + attestations/in‑toto, **Rekor** transparency log; **admission policies** to block unsigned/critical vulns.
* **Vuln & Posture**: Inspector, Wiz/Prisma, tfsec/checkov; CodeQL/Snyk in CI.
* **Data Security**: Vault Transform for tokenization; BYOK/HYOK; client‑side encryption SDKs for PII; DLP at egress; Macie for S3.
* **Compliance Automation**: Conformity packs (PCI/HIPAA), evidence collection (Config/CloudTrail/Activity Logs) → audit lake.

---

## 7) FinOps & Sustainability

* **Allocation**: **OpenCost** for K8s, CUR (AWS) → Athena/QuickSight; Azure Cost Management; GCP BQ exports.
* **Policy Gates**: Infracost delta thresholds in PR; budget & anomaly detection per OU/account; savings plans/RI planners.
* **Right‑Sizing**: Karpenter consolidation + VPA recommendations; EBS/GP3 downsizing; storage lifecycle policies (S3 IA/Glacier).
* **CarbonOps**: Track region/instance footprint (e.g., AWS CCF tool) and prefer greener regions where latency permits.

---

## 8) DR, HA & Chaos

* **Patterns**: Active/Active for stateless + cache; Active/Passive for heavy state; **global read replicas** (Aurora) with controlled promotion.
* **Backups**: AWS Backup vaults (immutable/locked) cross‑region; database PITR; FSx/NetApp snapshots; on‑prem Cohesity/Commvault integrated to S3.
* **Runbooks**: Route 53/GA failover; Kafka client re‑point; ArgoCD promote standby; Vault DR secondary promote.
* **GameDays**: **LitmusChaos** + Gremlin scenarios; quarterly DR drills with automated scoring.

---

## 9) Developer Experience (IDP) & Golden Paths

* **Backstage**: Software templates for service/new data pipeline/new ML model; docs, runbooks, ownership; scorecards (SLOs, security posture).
* **Paved‑Road**: Opinionated Helm charts + **OpenFeature** for flags; built‑in OTel, health probes, SLOs, PDBs, HPA/VPA defaults; Istio policies.
* **Self‑Service**: Backstage → Crossplane/ArgoCd/Service Catalog to provision RDS/Aurora/Redis/Kafka topics w/ quotas & guardrails.
* **Ephemeral Envs**: Preview namespaces per PR; short‑lived DNS/certs; teardown on merge.

---

## 10) Runbooks

* **New Account/Project**: Account vending (Control Tower Customizations); attach SCP set; enable baseline (CloudTrail/Config/Security Hub/GuardDuty/Detective); create **Network**+**Platform**+**Data** stacks; register with Thanos/Loki/Tempo.
* **New Region**: Deploy hub VPC/VNet; peer/attach to TGW/Cloud WAN; mesh expansion (east‑west GW); register resolvers; enable DX/ER path.
* **Disaster**: GA/Route 53 flip; Aurora global promotion; MSK client bootstrap swap; ArgoCD app-of-apps flips to standby; Vault DR secondary promote; validate via smoke synthetic.
* **Incident**: PagerDuty; isolate namespace/segment (NetworkPolicy quarantine); forensic snapshot; Falco/GuardDuty triage; Loki search by **traceID**; postmortem creation in Backstage.
* **Key Compromise**: Revoke Cosign keyless subject, rotate KMS CMKs, rotate Vault mounts, force image re‑sign & re‑deploy.

---

## 11) Governance, Risk & Compliance (GRC)

* **Control Library**: Mapped controls (CIS 1.x, ISO Annex A, PCI Req 3/7/10, HIPAA 164.xx) → IaC modules with evidence hooks.
* **Evidence**: Conftest attestations; Terraform state diffs; OPA decision logs; CloudTrail/Activity Logs → **Audit Lake** (S3/BQ/ADLS) with immutable retention.
* **Data Residency**: Region guardrails + key residency; CloudFront geo‑restrictions; egress deny‑lists.

---

## 12) Team Topology & RACI

* **Platform Core**: Networking (Cloud WAN/TGW), Platform (K8s/Argo/Backstage), Data (OLTP/Lakehouse), Security (IAM/Vault/SIEM), SRE (Observability/SLOs), FinOps.
* **Federated Product Teams**: Own services via golden paths; budgets & SLOs; on‑call rotation with SRE support.

---

## 13) Rollout Plan (Phased)

1. **Foundations**: Multi‑account/org guardrails; hub networks; identity/SSO; audit baseline.
2. **Platform MVP**: EKS + GitOps; Backstage; Observability core (Prom/Tempo/Loki/Grafana); FinOps plumbing.
3. **Data MVP**: Aurora/Dynamo; MSK; Lake foundation; CDC.
4. **Hybrid Link**: DX/ER, DNS resolvers, on‑prem clusters.
5. **Scale & Harden**: Multi‑region active/active, chaos/DR drills, supply‑chain enforcement, self‑service.

---

## 14) Bill of Materials (Services & Tools)

**AWS**: Organizations, Control Tower, IAM Identity Center, IAM, KMS/CloudHSM, Route 53 (+ Resolver/Health Checks), CloudFront, **Global Accelerator**, WAF, Shield Adv, VPC/TGW/GWLB/NAT/Privatelink/Lattice, EKS, ECS/Fargate, Lambda, Step Functions, EventBridge, SQS/SNS, API Gateway, S3, EBS, EFS, **FSx (Lustre/NetApp/Windows)**, RDS/Aurora, DynamoDB, MSK, Kinesis (opt), Glue/EMR/Athena, OpenSearch, ElastiCache, Redshift (opt), CloudTrail, Config, Security Hub, GuardDuty, Detective, Macie, Inspector, CloudWatch/X‑Ray/Logs, Backup, Budgets/Cost Explorer/Anomaly Detection.

**Azure**: Management Groups/Policies, Entra ID, VNet/Firewall/Private Link, AKS, Functions/Logic Apps, Event Hub/Service Bus, Cosmos DB/SQL MI, Storage/ADLS, Monitor/Log Analytics/Sentinel, Purview, Front Door/Traffic Manager, ExpressRoute.

**GCP**: Folders/Org Policies, VPC/Cloud Router, GKE, Cloud Functions/Workflows, Pub/Sub, Spanner/Cloud SQL/BigQuery, GCS, Cloud Armor, Cloud Interconnect.

**On‑Prem/SaaS/Open‑Source**: vSphere/vSAN/NSX‑T, NetApp/Pure, F5/NGINX, Infoblox, **Backstage**, ArgoCD, Crossplane, Istio/Cilium, Prometheus/Thanos/Loki/Tempo/Grafana, Pixie, Vault, Teleport, Kyverno/OPA, Trivy/Grype, Cosign/Syft, Debezium/Kafka, Trino, ClickHouse, Databricks (opt), Snowflake (opt), Cohesity/Commvault, NetBox.

---

## 15) What Runs Where (Quick Map)

* **User‑Facing Edge**: Multi‑CDN → GA → WAF → Mesh ingress → Services on EKS/AKS/GKE/OpenShift.
* **State**: OLTP in Aurora/Dynamo; analytics in ClickHouse/Snowflake/Trino; search in OpenSearch; caches in Redis.
* **Control Planes**: GitHub Actions, ArgoCD, Crossplane, Backstage, Vault, Teleport, SIEM.
* **Hybrid Bridges**: DX/ER, DNS resolvers, Kafka MirrorMaker (if needed), storage gateways, identity federation.

---

## 16) Risks & Mitigations (Not decided yet)

* **Global Consistency**: Use CRDT or idempotent eventing; limit cross‑region writes; apply saga patterns.
* **Blast Radius**: Hard tenant isolation (namespaces+network+IAM+KMS); per‑tenant keys; rate‑limits; cell‑based architecture.
* **Supply‑Chain**: Mandatory signatures + SBOM attestation; break‑glass reviewed by Security; provenance stored immutably.
* **Runaway Cost**: Quotas + Infracost gates + anomaly alerts; Karpenter consolidation; schedule down non‑prod.


---

## 🌍 Tech Stack Highlights

| Area                    | Tools / Services |
|--------------------------|------------------|
| **IaC & Policy**         | Terraform, Terragrunt, Crossplane, OPA, Kyverno |
| **Platform**             | EKS, OpenShift, Istio, ArgoCD, Backstage |
| **Data**                 | Aurora, DynamoDB, Kafka, ClickHouse, S3 |
| **Observability**        | Prometheus, Loki, Tempo, Grafana, Pixie |
| **Security**             | Vault, SPIFFE/SPIRE, Kyverno, Cosign |
| **CI/CD**                | GitHub Actions, Flagger, Karpenter |
| **FinOps**               | Infracost, OpenCost, CUR exports |

---

<div align="center">

⭐ **_“Build it once. Scale it everywhere.”_**  
_Designed for high availability, zero trust, and developer happiness._

</div>

---
