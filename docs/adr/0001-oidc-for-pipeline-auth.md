# ADR 0001: Authenticate the pipeline with OIDC federation

**Status:** Accepted

## Context

The pipeline needs to call Azure Resource Manager. The traditional approach stores a
service principal client secret in GitHub. That secret expires, has to be rotated, and
is a high-value target: anyone who can read it can act as the pipeline from anywhere.

## Decision

Use GitHub's OIDC token with Entra ID workload identity federation. Each job requests a
short-lived token and exchanges it for an Azure access token. The Entra ID application
only trusts specific GitHub subjects:

- `repo:<org>/<repo>:pull_request` for the read-only plan identity
- `repo:<org>/<repo>:environment:production` for the apply identity

## Consequences

- No client secret to store, leak or rotate.
- Apply can only run from the protected `production` environment, so required reviewers are enforced by trust, not by convention.
- Federated credentials are tied to repository and environment names; renaming either requires updating bootstrap.
- Two identities instead of one, which costs a little extra setup in exchange for a read-only path on pull requests.
