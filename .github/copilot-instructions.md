# GitHub Copilot Instructions for Sinclair

## Project Purpose

Sinclair is a Ruby gem that serves as a **foundation for developing other gems** by providing base classes and utility modules. It supplies:

- A method builder (`Sinclair`) for dynamically adding instance and class methods to any class.
- `Sinclair::Configurable` / `Sinclair::Config` for adding configuration to classes and modules.
- `Sinclair::Options` for structured, validated option objects.
- `Sinclair::EnvSettable` for reading environment variables through class methods.
- `Sinclair::Comparable` for easy `==` comparisons based on selected attributes.
- `Sinclair::Model` for quick creation of simple plain-Ruby model classes.
- RSpec matchers (`Sinclair::Matchers`) to test method-building behaviour.

All PRs, code, comments, and documentation must be written in **English**.

## Development Workflow

Development runs inside **Docker** using **docker-compose**.

- **Enter the development environment:**
  ```bash
  make dev
  ```
  This runs `docker-compose run sinclair /bin/bash`, dropping you into an interactive shell inside the container with the project mounted at `/home/app/app`.

- The Docker image is built from `Dockerfile`; a CircleCI-specific image is available via `Dockerfile.circleci`.

## Tooling & CI

The CI pipeline (`.circleci/config.yml`) runs the following checks on every PR:

- **RSpec** – unit/integration test suite:
  ```bash
  bundle exec rspec
  ```
- **Rubocop** – Ruby style and linting:
  ```bash
  rubocop
  ```
- **Yardstick** – documentation coverage check:
  ```bash
  bundle exec rake verify_measurements
  ```
- **YARD** – API documentation is generated with YARD:
  ```bash
  yard
  ```

All four checks must pass before a PR can be merged.

## Testing Guidelines

- **Aim for at least one spec per source file.** Files explicitly excluded from this requirement are listed in `config/check_specs.yml`.
- **Avoid mocks.** Prefer real objects and stubs only when there is no reasonable alternative.
- **One expectation per example.** Keep each `it` block focused on a single assertion.
- Place specs under `spec/` mirroring the structure of `lib/`.

## Code Quality & Style

- Follow **Clean Code** principles: clear naming, small focused methods, and minimal duplication.
- Follow **Sandi Metz** Ruby rules:
  - Classes should be small and have a **single responsibility**.
  - Methods should be short and do one thing.
  - Respect the **Law of Demeter** – avoid long method chains that reach through unrelated objects.
- Document all public methods and classes with **YARD** doc-comments.
