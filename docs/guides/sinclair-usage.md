# Sinclair – Usage Guide for Dependent Projects

This document describes how to use the **sinclair** gem in your project.
Copy this file and the [`sinclair/`](sinclair/) directory into your project's
`docs/guides/` directory so that GitHub Copilot is aware of the patterns and
conventions Sinclair provides.

**Current release**: 3.1.0
**Docs**: <https://www.rubydoc.info/gems/sinclair/3.1.0>

---

## Guides

- [Installation](sinclair/installation.md)
- [Sinclair – Dynamic Method Builder](sinclair/method-builder.md)
- [Sinclair::Configurable – Application Configuration](sinclair/configurable.md)
- [Sinclair::Options – Validated Option Objects](sinclair/options.md)
- [Sinclair::EnvSettable – Environment Variable Access](sinclair/env-settable.md)
- [Sinclair::Comparable – Attribute-based Equality](sinclair/comparable.md)
- [Sinclair::Model – Quick Plain-Ruby Models](sinclair/model.md)
- [Sinclair::Caster – Type Casting](sinclair/caster.md)
- [Sinclair::Matchers – RSpec Matchers](sinclair/matchers.md)
- [Complete Example](sinclair/complete-example.md)

---

## Features Overview

| Feature | Class / Module | Purpose | Guide |
|---|---|---|---|
| Method builder | `Sinclair` | Add instance/class methods dynamically | [method-builder.md](sinclair/method-builder.md) |
| Configuration | `Sinclair::Configurable` + `Sinclair::Config` | Read-only config with defaults | [configurable.md](sinclair/configurable.md) |
| Options | `Sinclair::Options` | Validated parameter objects | [options.md](sinclair/options.md) |
| Env variables | `Sinclair::EnvSettable` | Read ENV vars via class methods | [env-settable.md](sinclair/env-settable.md) |
| Equality | `Sinclair::Comparable` | Attribute-based `==` | [comparable.md](sinclair/comparable.md) |
| Plain models | `Sinclair::Model` | Quick data-model classes | [model.md](sinclair/model.md) |
| Type casting | `Sinclair::Caster` | Extensible type transformations | [caster.md](sinclair/caster.md) |
| RSpec matchers | `Sinclair::Matchers` | Test method-builder behaviour | [matchers.md](sinclair/matchers.md) |
