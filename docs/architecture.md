# Architecture notes

## How the code maps to the design

| Design element | Where it lives |
|---|---|
| Management group hierarchy | `modules/management-groups` |
| Azure Policy guardrails | `modules/policy`, custom rules in `policies/definitions` |
| Central logging, Defender | `modules/monitoring` |
| Hub network, firewall, bastion | `modules/networking-hub` |
| Workload spokes | `modules/networking-spoke` |
| Platform composition | `environments/platform` |
| Workload composition | `environments/landing-zones` |
| State backend and OIDC identities | `bootstrap` |
| Delivery pipeline | `.github/workflows` |

## State layout

| State file | Contents | Written by |
|---|---|---|
| `platform.tfstate` | Management groups, policy, monitoring, hub | platform environment |
| `landing-zones.tfstate` | Spokes | landing-zones environment, reads platform outputs |

Splitting state limits blast radius: a bad change to a workload spoke cannot touch the
hub or the policy baseline.

## Policy rollout approach

1. Apply with `policy_enforce = false` so assignments only audit.
2. Review the compliance report and fix or exempt real findings.
3. Switch `policy_enforce = true` in a pull request and merge.

Policies in this baseline use Deny and Audit effects. Auto-remediation policies
(DeployIfNotExists) are not yet included; subscription-level logging and Defender are
configured directly in `modules/monitoring` instead.

## Identity model

| Identity | Used by | Trust condition | Rights |
|---|---|---|---|
| plan | pull request plans | GitHub subject `pull_request` | Reader, plus blob access for state locking |
| apply | `main` apply and compliance check | GitHub subject `environment:production` | Contributor, Resource Policy Contributor, Management Group Contributor |

A pull request from a fork or an unreviewed branch can plan but cannot change anything.
