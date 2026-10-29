<div align="center">

# 👋 Hi, I'm Aniket Kumar

### ⚙️ DevOps Engineer &nbsp;|&nbsp; ☁️ Azure &nbsp;|&nbsp; 🏗️ Terraform &nbsp;|&nbsp; ☸️ Kubernetes &nbsp;|&nbsp; 🚀 CI/CD

<a href="https://github.com/aniket-devop">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=22&pause=1200&color=38BDF8&center=true&vCenter=true&width=700&height=45&lines=I+make+infrastructure+boring+in+the+right+way;No+manual+clicks.+Everything+in+code.;Terraform+%E2%86%92+AKS+%E2%86%92+GitOps+with+ArgoCD;Open+to+DevOps+%2F+Cloud+Engineer+roles" alt="typing"/>
</a>

<br/>

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/aniket484)
[![Email](https://img.shields.io/badge/Email-Say%20Hi-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:aniketkmr484@gmail.com)
[![Projects](https://img.shields.io/badge/See-My%20Projects-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)](#-featured-projects)
[![Hiring](https://img.shields.io/badge/Status-Open%20to%20Work-22C55E?style=for-the-badge&logo=checkmarx&logoColor=white)](#-lets-connect)

<img src="https://komarev.com/ghpvc/?username=aniket-devop&label=Profile%20Views&color=0e75b6&style=flat" alt="profile views"/>

<br/><br/>

**[About](#-about-me)** · **[Journey](#-career-journey)** · **[How I Ship](#-how-i-ship)** · **[Stack](#-tech-stack)** · **[Projects](#-featured-projects)** · **[Stats](#-github-stats)** · **[Contact](#-lets-connect)**

<br/>

| 🧑‍💻 Experience | ☁️ Primary Cloud | 🏗️ IaC | ☸️ Orchestration | 📍 Based in |
|:---:|:---:|:---:|:---:|:---:|
| **2 Years** | **Azure** | **Terraform** | **Kubernetes / AKS** | **Bengaluru, India** |

</div>

<br/>

> [!IMPORTANT]
> ### ⚡ Recruiter TL;DR (30 seconds)
> 🟢 **Open to DevOps / Cloud Engineer roles** · full-time · Bengaluru or remote
>
> | What | Proof |
> |---|---|
> | ☸️ **Ships to Kubernetes** | [Live AKS platform](#-axion-intelligence-platform--live-on-aks), built end-to-end: Terraform → ACR → AKS |
> | 🔄 **GitOps, not click-ops** | ArgoCD reconciles from Git. CI never touches the cluster. Rollback = `git revert` |
> | 🔐 **Security built in** | Trivy gate, deny-by-default NSGs, RBAC scoped to the resource group |
> | 📚 **Honest engineering** | Every repo documents its scope, gaps and roadmap |

---

## 🧑‍💻 About Me

I'm a DevOps Engineer with **2 years of hands-on experience** across Azure infrastructure, Terraform, CI/CD automation, containerized deployments and DevSecOps. My day job is Azure and pipelines. My own time goes into projects I build to actually *run*, not just to demo, because I'd rather find out where a design breaks on my own dime than on a client's.

```yaml
aniket:
  role: DevOps Engineer @ DevOps Insiders
  currently_building: [Azure/AKS platform projects, GitOps pipelines with ArgoCD]
  daily_drivers: [Terraform, AKS, Helm, GitHub Actions, Azure DevOps]
  ask_me_about: [Terraform module design, AKS networking, GitOps patterns]
  education: BCA, Chandigarh Group of Colleges, Mohali
  open_to_work: true
```

---

## 🛤️ Career Journey

| When | Role | What I did |
|:---:|---|---|
| **Nov 2024 → Now** | **DevOps Engineer** · DevOps Insiders | Azure infrastructure with Terraform (resource groups, VNets, AKS), CI/CD in GitHub Actions and Azure DevOps, Helm deployments, Prometheus/Grafana monitoring, DevSecOps scanning |
| **Aug 2023 → Oct 2024** | **DevOps & Cloud Engineer** · Freelance client projects | Airflow on Docker Compose + PostgreSQL, StatsD → Prometheus → Grafana monitoring, Terraform and shell deployment scripts |

<details>
<summary><b>💼 Day-to-day responsibilities at DevOps Insiders (click to expand)</b></summary>
<br/>

- Provision and manage Azure infrastructure with Terraform: resource groups, virtual networks and AKS
- Build and maintain CI/CD pipelines in GitHub Actions and Azure DevOps to automate build, test and deployment
- Containerize applications with Docker and deploy to Kubernetes/AKS using Helm charts
- Integrate security and IaC scanning (Trivy, TFLint, TFSec, Checkov) into the delivery lifecycle
- Set up monitoring and observability with Prometheus and Grafana
- Troubleshoot pipeline, infrastructure and deployment issues across environments
- Work with developers and QA to keep release cycles smooth and reliable

</details>

---

## 🧭 How I Work

<table>
<tr>
<td width="33%" valign="top" align="center">

### 🔁 Reproducible
Everything lives in Terraform and YAML. If it can't be rebuilt from code, it isn't done.

</td>
<td width="33%" valign="top" align="center">

### 🔐 Secure by default
Deny-by-default NSGs, RBAC scoped to the resource group, and a Trivy gate before any image ships.

</td>
<td width="33%" valign="top" align="center">

### 📚 Honest engineering
Every project documents its scope, its gaps and its roadmap. No overstated claims.

</td>
</tr>
</table>

---

## 🔄 How I Ship

My GitOps pipeline, end to end (from the [GitOps project](https://github.com/aniket-devop/gitops-kubernetes-config)):

```mermaid
%%{init: {'theme':'base','themeVariables':{'primaryColor':'#0B3A6F','primaryTextColor':'#ffffff','primaryBorderColor':'#38BDF8','lineColor':'#38BDF8','secondaryColor':'#0F1A2E','tertiaryColor':'#0F1A2E','fontSize':'14px'}}}%%
flowchart LR
    A([👨‍💻 Git push]) --> B[⚙️ GitHub Actions<br/>build + test]
    B --> C[🔐 Trivy scan<br/>CRITICAL gate]
    C --> D[(📦 GHCR<br/>image)]
    D --> E[📝 GitOps repo<br/>image tag commit]
    E --> F[🔄 ArgoCD<br/>reconcile]
    F --> G([☸️ Kubernetes])
```

> [!NOTE]
> **CI never touches the cluster.** Deployment and rollback happen through Git alone: a `git revert` on the image-tag commit was enough for ArgoCD to restore the previous version.

---

## 🛠️ Tech Stack

<div align="center">

| | |
|:---|:---|
| **☁️ Cloud & IaC** | <img src="https://skillicons.dev/icons?i=azure,aws,terraform" alt="cloud"/> |
| **📦 Containers & GitOps** | <img src="https://skillicons.dev/icons?i=docker,kubernetes" alt="containers" align="top"/> <img src="https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white" alt="Helm" align="top"/> <img src="https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white" alt="ArgoCD" align="top"/> |
| **🚀 CI/CD & Security** | <img src="https://skillicons.dev/icons?i=githubactions,git,github" alt="cicd" align="top"/> <img src="https://img.shields.io/badge/Azure_DevOps-0078D7?style=for-the-badge&logo=azuredevops&logoColor=white" alt="Azure DevOps" align="top"/> <img src="https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge&logo=aqua&logoColor=white" alt="Trivy" align="top"/> |
| **📊 Monitoring** | <img src="https://skillicons.dev/icons?i=prometheus,grafana" alt="monitoring"/> |
| **💻 Languages & OS** | <img src="https://skillicons.dev/icons?i=python,bash,linux,fastapi,react,postgres" alt="languages"/> |

<sub>🔐 IaC security scanning: TFLint · TFSec · Checkov &nbsp;|&nbsp; ☁️ Azure is my primary cloud; AWS is hands-on project experience.</sub>

</div>

---

## 🏗️ Featured Projects

> [!TIP]
> Every project has an **architecture diagram**, an **honest scope** section and a **roadmap** in its repo README.

### ⭐ Axion Intelligence Platform · live on AKS

27 simulated industrial assets (pumps, motors, compressors) across five refinery sites stream temperature, vibration and current readings every 5 seconds into a dashboard with 3D digital twins and real-time health scoring.

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![AKS](https://img.shields.io/badge/AKS%20%2F%20ACR-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=fastapi&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=flat-square&logo=react&logoColor=61DAFB)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)

https://github.com/aniket-devop/axion-cloud-infrastructure/raw/main/docs/demo/axion-deployment-demo.mp4

**Delivery path:**

```mermaid
%%{init: {'theme':'base','themeVariables':{'primaryColor':'#0B3A6F','primaryTextColor':'#ffffff','primaryBorderColor':'#38BDF8','lineColor':'#38BDF8','secondaryColor':'#0F1A2E','tertiaryColor':'#0F1A2E','fontSize':'14px'}}}%%
flowchart LR
    T[🏗️ Terraform<br/>Azure footprint] --> R[(📦 ACR)]
    G[⚙️ GitHub Actions<br/>build + push] --> R
    R --> K[☸️ AKS<br/>Kubernetes manifests]
    K --> L[🌐 LoadBalancer<br/>UI + API]
```

**Runtime:**

```mermaid
%%{init: {'theme':'base','themeVariables':{'primaryColor':'#0B3A6F','primaryTextColor':'#ffffff','primaryBorderColor':'#38BDF8','lineColor':'#22D3A6','secondaryColor':'#0F1A2E','tertiaryColor':'#0F1A2E','fontSize':'14px'}}}%%
flowchart LR
    A[🏭 27 simulated assets<br/>every 5 s] --> I[📥 Ingestion service]
    I --> D[(🗄️ PostgreSQL)]
    D --> Q[🧮 Query + health scoring<br/>service]
    Q --> U[🖥️ React dashboard<br/>3D digital twins]
```

- 🧩 Ingestion (write-heavy) and query (aggregation + health scoring) are separate services, so each scales independently
- 🏗️ Terraform `for_each` over an `environments` map renders dev/staging/prod from one module tree
- 🔑 `admin_enabled = false` on ACR, so identity-based auth instead of shared admin credentials

[![View Repo](https://img.shields.io/badge/→%20View%20Repo-38BDF8?style=for-the-badge&logo=github&logoColor=0B3A6F)](https://github.com/aniket-devop/axion-cloud-infrastructure)

<br/>

### 🧰 More Projects

<table>
<tr>
<td width="50%" valign="top">

#### 🔄 GitOps CI/CD Pipeline
CI builds, scans and publishes an image; ArgoCD deploys it.

- 🔒 Trivy `CRITICAL` gate fails the job before GHCR
- 🔒 Non-root container on `python:3.12-alpine`
- 🔄 Rollback is a pure `git revert`

![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?style=flat-square&logo=githubactions&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=flat-square&logo=aqua&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-0F1689?style=flat-square&logo=helm&logoColor=white)
![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=flat-square&logo=argo&logoColor=white)

**[App repo](https://github.com/aniket-devop/gitops-ci-pipeline) · [GitOps repo](https://github.com/aniket-devop/gitops-kubernetes-config)**

</td>
<td width="50%" valign="top">

#### 🔐 Azure Network Foundation
Hub-and-spoke network built with Terraform.

- 🛡️ Firewall-forced egress via route table
- 🚫 Bastion instead of a jump box, no VM has a public IP
- 🔑 RBAC scoped to the resource group, not the subscription

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![Firewall](https://img.shields.io/badge/Azure%20Firewall-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![Key Vault](https://img.shields.io/badge/Key%20Vault-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)

**[View repo](https://github.com/aniket-devop/azure-network-foundation-terraform)**

</td>
</tr>
<tr>
<td width="50%" valign="top">

#### 🌱 AWS Landing Network
The same private-compute pattern, rebuilt on AWS.

- 🌐 Multi-AZ VPC, ALB in front of private EC2
- 📤 Outbound-only access through NAT Gateway
- 🔒 Remote state in S3 with DynamoDB locking

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/VPC%20%2F%20ALB%20%2F%20EC2-232F3E?style=flat-square&logo=amazonaws&logoColor=white)
![S3](https://img.shields.io/badge/S3%20%2B%20DynamoDB-569A31?style=flat-square&logo=amazons3&logoColor=white)

**[View repo](https://github.com/aniket-devop/aws-terraform-landing-zone-project)**

</td>
<td width="50%" valign="top">

#### 📊 Airflow Observability Pipeline
Freelance client project, containerized and monitored.

- 🔧 Re-architected to LocalExecutor + PostgreSQL
- 📈 StatsD → Prometheus → Grafana metrics pipeline
- ⚡ Whole stack starts with one `docker compose up`

![Airflow](https://img.shields.io/badge/Airflow-017CEE?style=flat-square&logo=apacheairflow&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat-square&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat-square&logo=grafana&logoColor=white)

**[View repo](https://github.com/aniket-devop/airflow-docker-grafana-monitoring)**

</td>
</tr>
</table>

<details>
<summary><b>🔐 See the Azure network design (click to expand)</b></summary>
<br/>

```mermaid
%%{init: {'theme':'base','themeVariables':{'primaryColor':'#0B3A6F','primaryTextColor':'#ffffff','primaryBorderColor':'#38BDF8','lineColor':'#38BDF8','secondaryColor':'#0F1A2E','tertiaryColor':'#0F1A2E','fontSize':'14px'}}}%%
flowchart TB
    subgraph HUB[🏢 Hub VNet]
        FW[🛡️ Azure Firewall]
        BA[🔑 Azure Bastion]
    end
    subgraph SPOKE[🧩 Spoke VNet]
        NSG[🚫 NSG: deny-by-default]
        AKS[☸️ snet-aks<br/>AKS subnet]
    end
    KV[(🔐 Key Vault<br/>RBAC + network ACL)]
    AKS -- route table: all egress --> FW
    BA -. admin access, no public IPs .-> SPOKE
    NSG --- AKS
    SPOKE -.-> KV
```

</details>

---

## 🗺️ Currently Learning & Roadmap

| Status | Focus |
|:---:|---|
| 🔨 **Building** | More AKS + GitOps patterns, ArgoCD with multi-environment promotion |
| 📖 **Exploring** | Policy-as-code, deeper Kubernetes security, observability on AKS |
| 🎯 **Next** | Cloud certifications and larger production-style platform projects |

---

## 🔥 GitHub Stats

<div align="center">

<img src="https://streak-stats.demolab.com/?user=aniket-devop&hide_border=true&theme=dark&background=0D1117&ring=38BDF8&fire=22D3A6&currStreakLabel=38BDF8" alt="streak"/>

<br/><br/>

<img height="170" src="https://github-readme-stats.vercel.app/api?username=aniket-devop&show_icons=true&theme=tokyonight&hide_border=true&count_private=true" alt="stats"/>
<img height="170" src="https://github-readme-stats.vercel.app/api/top-langs/?username=aniket-devop&layout=compact&theme=tokyonight&hide_border=true" alt="languages"/>

<br/><br/>

<img src="https://github-readme-activity-graph.vercel.app/graph?username=aniket-devop&bg_color=0D1117&color=38BDF8&line=22D3A6&point=ffffff&area=true&hide_border=true" alt="activity graph" width="95%"/>

</div>

---

## 📬 Let's Connect

Hiring for a DevOps / Cloud role, or want to talk Terraform, AKS or GitOps? **I read every message.**

<div align="center">

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Message%20me-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/aniket484)
[![Email](https://img.shields.io/badge/Email-Send%20a%20note-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:aniketkmr484@gmail.com)

<br/>

⭐ *If something here helped you, a star on my repos means a lot.*

**Thanks for visiting 💙**

</div>
