# ADR 0002: Separate platform and landing-zone state

**Status:** Accepted

## Decision

Platform resources (hierarchy, policy, monitoring, hub) and landing-zone resources
(spokes) use separate Terraform state files and are applied in that order.

## Reasoning

- A mistake while adding a workload cannot destroy shared infrastructure.
- Different teams can eventually own different environments with different approvals.
- Plans stay fast and readable because each only covers its own scope.

## Trade-off

Landing zones read hub details through `terraform_remote_state`, which couples the two
environments by output names. Treat platform outputs as a contract and change them
deliberately.
