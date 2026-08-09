# Contributing

## Commit Guidelines

- **Atomic and Unitary:** Each commit must represent a single logical change.
  *Example:*
  - Good: `Add cached option to MethodDefinition`
  - Bad: `Add cached option and refactor MethodBuilder`
- **No Unrelated Changes:** Do not mix unrelated changes in the same commit.
- **Separate Refactoring:** Whenever possible, separate refactoring commits from new feature or bugfix commits.

## Pull Requests

- **Descriptive Summary:** Every PR must include a clear and descriptive summary of its purpose and changes.
- **PR Description Files:** If a description cannot be provided directly in the PR, generate a file with the PR description (e.g., `docs/agents/issues/<issue_id>_description.md`), but do not commit this file.

## Definition of Done for PRs

A PR is considered complete when:

- The stated objective has been achieved.
- All tests are passing.
- Linting passes without errors.
- Code coverage is as high as reasonably possible.
- Code is not overly complex:
  - Classes and methods should have clear, focused responsibilities.
  - If a class or method is taking on too many responsibilities, refactor to simplify.
  - Methods should be small and do exactly one thing. If a method is growing, extract parts into private helper methods or separate classes.
  - *Example (pseudo-code):*
    ```ruby
    # Good: Each method does one thing
    class Worker
      def fetch_job
        # ...
      end

      def process_job(job)
        # ...
      end
    end

    # Bad: Method does too much
    class Worker
      def run
        fetch_job
        process_job(job)
        send_metrics
        cleanup
      end
    end
    ```
  - This requirement applies primarily to source code. For specs, refactor only if there is excessive duplication.

### CI Checks

Before a PR is considered complete, all CI checks defined in `.circleci/config.yml` must pass locally. This is a single-gem project (not a monorepo), so every job below applies to every change — there is no folder-based filtering.

| Job | Local command(s) |
|-----|-------------------|
| `test` | `bundle exec rspec` |
| `checks` | `rubocop`, `bundle exec rake verify_measurements` (Yardstick doc coverage), `check_specs` (spec-per-source-file coverage) |
| `build-and-release` | Release-only (gem build/push on tagged `master` builds) — not required for PRs |

Run all `test` and `checks` commands above before opening a PR. If new CircleCI jobs are added in the future, update this table.

This same process must be followed when **planning how to resolve an issue**: include a final step in the plan that lists the CI commands above to run before opening a PR.

## Code Organization

### File Responsibility: Class Declarers vs Scripts

Every source file under `lib/` (excluding spec files) must act as a **class or module declarer** — it should define and (via `autoload`, in this gem) expose one class or module. Files must not act as **scripts** (i.e., they must not execute logic at load time or perform side effects directly).

*Example:*
```ruby
# Good: class declarer — defines a class, no side effects at load time
class MethodBuilder
  def build(definitions)
    # ...
  end
end

# Bad: script — executes logic at file-load time
builder = MethodBuilder.new
builder.build(definitions)
```

Spec files are exempt from this rule and may execute setup code (e.g. `describe`/`let`/`before`) freely.

### File Naming: snake_case for Class Files

Files that define a class or module must use **snake_case** naming, matching the class/module name exactly, with one file per directory level of namespacing.

*Examples:*

- `method_builder.rb` for `class MethodBuilder`
- `method_builder/base.rb` for `class MethodBuilder::Base`
- `equals_checker/reader.rb` for `class EqualsChecker::Reader`

This applies to both source files and their corresponding spec files, mirrored under `spec/`:
- `lib/sinclair/method_builder.rb` → spec: `spec/lib/sinclair/method_builder_spec.rb`
- `lib/sinclair/equals_checker/reader.rb` → spec: `spec/lib/sinclair/equals_checker/reader_spec.rb`

Non-class files (e.g. plain utility scripts outside `lib/`) use snake_case at the author's discretion.

### Method Order: Public Before Private

Within a class, **public methods must be declared before private methods**. Private methods (below the `private` keyword) serve as implementation helpers and should appear at the end of the class body.

*Example:*
```ruby
# Good: public methods first, private methods last
class Worker
  def run
    prepare
    execute
  end

  def status
    # ...
  end

  private

  def prepare
    # ...
  end

  def execute
    # ...
  end
end

# Bad: private methods mixed in with or before public methods
class Worker
  private

  def prepare
    # ...
  end

  public

  def run
    # ...
  end
end
```

## Dependency Injection

Classes must receive their dependencies (data, configuration, collaborators) as constructor arguments (`initialize`). A class must never reach out to load files, read environment variables, or fetch configuration on its own — the exception is `Sinclair::EnvSettable`/`Sinclair::Config`, whose entire purpose is to be that boundary; classes that use them should still receive the resulting values, not read `ENV` or config directly themselves.

This makes every class independently testable: specs simply instantiate the class with the data they need, without touching the filesystem or environment.

*Example:*
```ruby
# Good: class receives data as an argument — easy to test
class Router
  def initialize(data)
    @data = data
  end

  def build
    # ...
  end
end

# Bad: class loads its own config — hard to test and couples to the filesystem
class Router
  def build
    data = YAML.load_file('./data.yml') # ❌
    # ...
  end
end
```

This principle applies to all classes — including helpers and builders. If a class needs data, it gets it through its constructor.

## Refactoring Guidelines

When refactoring, aim to:

- **Reduce Code Duplication:**
  *Example:* Move repeated setup code in specs to a factory method.
  ```ruby
  # Good
  def build_category(**attrs)
    { id: 1, name: 'Books', **attrs }
  end
  # In specs:
  category = build_category(id: 2)

  # Bad
  category = { id: 2, name: 'Books' }
  # ...repeated in many spec files
  ```
- **Avoid Mocks:** Prefer real objects and stubs only when there is no reasonable alternative (per `AGENTS.md`'s testing guidelines).
- **Keep One Expectation Per Example:** Split multi-assertion `it` blocks into focused examples.
