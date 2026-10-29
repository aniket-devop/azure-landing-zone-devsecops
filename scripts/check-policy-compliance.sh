#!/usr/bin/env bash
# Fails if more resources are non-compliant than the allowed threshold.
#
#   MANAGEMENT_GROUP   management group ID to evaluate (required)
#   MAX_NONCOMPLIANT   allowed number of non-compliant resources (default 0)
#
# Note: Azure Policy compliance data can lag a deployment by several minutes. A freshly
# assigned policy may report stale results until the next evaluation cycle.
set -euo pipefail

: "${MANAGEMENT_GROUP:?MANAGEMENT_GROUP is required}"
MAX_NONCOMPLIANT="${MAX_NONCOMPLIANT:-0}"

echo "Evaluating policy compliance for management group: ${MANAGEMENT_GROUP}"

noncompliant="$(az policy state summarize \
  --management-group "${MANAGEMENT_GROUP}" \
  --query 'results.nonCompliantResources' \
  --output tsv)"
noncompliant="${noncompliant:-0}"

echo "Non-compliant resources: ${noncompliant} (allowed: ${MAX_NONCOMPLIANT})"

if [ "${noncompliant}" -gt "${MAX_NONCOMPLIANT}" ]; then
  echo "::error::${noncompliant} non-compliant resources exceed the threshold of ${MAX_NONCOMPLIANT}"
  echo "Top offending policies:"
  az policy state summarize \
    --management-group "${MANAGEMENT_GROUP}" \
    --query 'policyAssignments[?results.nonCompliantResources>`0`].{assignment:policyAssignmentId, nonCompliant:results.nonCompliantResources}' \
    --output table || true
  exit 1
fi

echo "Compliance check passed."
