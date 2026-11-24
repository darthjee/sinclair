```text
<type>(<scope>): <subject> (issue #<id>)

<optional body: what was done and why, if not obvious>

Addresses-Comment: <optional: URL of the PR comment this commit addresses>

Co-Authored-By: <AI model name> <AI model email>
Co-Authored-By: <agent> agent <agent email>
```

Note: unlike the model line above (always the running AI model's own
canonical noreply address), the agent line's email is independently
configurable per agent via the "git.email" key (a template such as
"you+{agent}@example.com", with "{agent}" substituted for the actual
agent name, e.g. "architect" or "backend") in
.claude/state/arcanum-config.json (local) or
.claude/configuration/arcanum-repo-config.json (repo) — see
docs/guides/arcanum-repo-config.md. When "git.email" is unset, the agent
line falls back to the same address as the model line, reproducing the
old, single-shared-email template's output.

The model line above can be omitted entirely by setting the
"git.omit_model_coauthor" key to "true" in the same three locations
(local state, repo config, or global config — see
docs/guides/arcanum-repo-config.md) — the agent line is always still
emitted regardless of this setting.

This file's mere presence (as "commit_message_template-2.0.md", not its
content) is what switches the commit scripts onto this new, two-distinct-
email behavior — the content itself is never parsed at runtime, it is
purely human-facing documentation of the shape above.
