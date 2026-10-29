# Getting started

Follow these steps once. After that, every change goes through a pull request.

## Prerequisites

- Three Azure subscriptions (or one, for a trial run): management, connectivity, workload
- Terraform >= 1.6, Azure CLI, and a user with:
  - Owner on the subscription that will hold state
  - Permission to create Entra ID app registrations
  - Management Group Contributor (or higher) at the tenant root, with
    "Access management for Azure resources" elevated if you are a Global Administrator
- This repository forked or cloned into your own GitHub account

## 1. Bootstrap state and pipeline identities

```bash
az login
cd bootstrap
cp terraform.tfvars.example terraform.tfvars   # edit the values
terraform init
terraform apply
terraform output github_repository_variables
```

If the first apply fails while creating the storage container, wait a minute for the
role assignment to propagate and apply again.

## 2. Configure GitHub

**Settings, Secrets and variables, Actions, Variables.** Add the values printed by bootstrap, plus your subscriptions:

| Variable | Source |
|---|---|
| `AZURE_TENANT_ID` | bootstrap output |
| `AZURE_PLAN_CLIENT_ID` | bootstrap output (read-only identity) |
| `AZURE_APPLY_CLIENT_ID` | bootstrap output (write identity) |
| `TFSTATE_RESOURCE_GROUP` | bootstrap output |
| `TFSTATE_STORAGE` | bootstrap output |
| `TFSTATE_CONTAINER` | bootstrap output |
| `MANAGEMENT_SUBSCRIPTION_ID` | your management subscription |
| `CONNECTIVITY_SUBSCRIPTION_ID` | your connectivity subscription (can equal the management one for a trial) |
| `WORKLOAD_SUBSCRIPTION_ID` | your workload subscription |
| `ORG_MANAGEMENT_GROUP_ID` | the `org_id` you chose, e.g. `contoso` |

These are identifiers, not secrets. No client secret exists anywhere in this setup.

**Settings, Environments, New environment `production`:** add required reviewers. This is the approval gate; the apply workflow will not run without it.

**Settings, Branches:** protect `main`, require pull requests, and require the CI checks to pass.

## 3. Make it yours

Edit `environments/platform/terraform.tfvars` (org name, regions, tags). The defaults start with `policy_enforce = false` and `deploy_firewall = false` on purpose: review compliance and cost before turning them on.

Run formatting once before your first push, otherwise the CI format check will fail:

```bash
terraform fmt -recursive
```

## 4. Ship it

Open a pull request. CI lints, scans for secrets and misconfigurations, and posts the plan as a comment. Merge to `main`, approve the `production` environment, and the apply workflow deploys platform first, then landing zones, then checks policy compliance.

## Cost notes

Azure Firewall (Standard) and Bastion bill hourly while they exist. Leave `deploy_firewall` and `deploy_bastion` off while experimenting, and destroy test environments when done.

## Known limitations

- Platform apply configures Defender and logging for the management subscription only. Applying them to every subscription is future work.
- Landing zone environment deploys spokes into one workload subscription per run.
- The state account is reachable over its public endpoint (Entra ID auth only). Private endpoints need self-hosted runners.
- The first PR on a fresh tenant will show the landing-zones plan failing until platform has been applied once, because it reads the hub details from platform state.
