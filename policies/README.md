# Policy-as-code

Built-in policies are referenced directly in `modules/policy`. Anything custom lives here.

Add a new rule by dropping a JSON file into `definitions/`:

```json
{
  "displayName": "...",
  "description": "...",
  "mode": "Indexed",
  "metadata": { "category": "..." },
  "policyRule": { "if": {}, "then": { "effect": "deny" } }
}
```

On the next apply it is created as a custom definition and assigned at the organisation
management group. The pull request pipeline shows the plan, so policy changes are
reviewed exactly like infrastructure changes.

Tip: test a new rule with `enforce = false` on the policy module first, review the
compliance report, then switch to enforcement.
