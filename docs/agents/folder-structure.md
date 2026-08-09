# Folder Structure

## Project Root

| Directory / File | Description |
|-----------------|-------------|
| `lib/`          | Gem source code (`Sinclair` and its submodules). |
| `spec/`         | RSpec test suite, mirroring the structure of `lib/`. |
| `config/`       | Configuration for dev/CI tooling: `check_specs.yml` (spec coverage exceptions), `rubycritc.rb`, `yardstick.rb`/`yardstick.yml` (YARD documentation coverage). |
| `docs/agents/`  | Agent-facing documentation: architecture, flow, folder structure, plans, and issues. |
| `doc/`          | Generated YARD API documentation (build artifact, not hand-maintained). |
| `.circleci/`    | CircleCI pipeline configuration (`config.yml`). |
| `.github/`      | GitHub-specific files: PR/commit templates, Copilot instructions, usage notes. |
| `Dockerfile`    | Image used for local development (`make dev`). |
| `Dockerfile.circleci` | Image used by the CircleCI pipeline. |
| `docker-compose.yml` | Defines the `sinclair` development service. |
| `Makefile`      | Shortcuts for common tasks (e.g. `make dev`). |
| `Rakefile`      | Rake tasks, including `verify_measurements` (Yardstick check). |
| `sinclair.gemspec` | Gem specification (dependencies, metadata). |
| `Gemfile`       | Bundler dependencies. |
| `.rubocop.yml` / `.rubocop_todo.yml` | Rubocop style configuration. |
| `.rspec`        | RSpec runner configuration. |
| `README.md`     | Project overview and usage documentation. |
| `WARNINGS.md`   | Known warnings/caveats for users of the gem. |
| `LICENSE`       | Project license. |

## lib/sinclair (source layout)

| Subdirectory | Description |
|--------------|-------------|
| `options/`   | `Sinclair::Options` — structured, validated option objects. |
| `core_ext/`  | Core Ruby extensions used internally. |
| `config/`    | `Sinclair::Configurable` / `Sinclair::Config` — configuration support for classes and modules. |
| `caster/`    | Type-casting helpers used by options/config. |
| `settable/`  | `Sinclair::EnvSettable` — reading environment variables through class methods. |
| `model/`     | `Sinclair::Model` — quick creation of simple plain-Ruby model classes. |
| `comparable/`| `Sinclair::Comparable` — `==` comparisons based on selected attributes. |
| `matchers/`  | `Sinclair::Matchers` — RSpec matchers for testing method-building behaviour. |
| `method_builder/` | Internals for dynamically building instance/class methods. |
| `method_definition/` | Definition objects describing methods to be built. |
| `equals_checker/` | Internals backing `Sinclair::Comparable`. |
