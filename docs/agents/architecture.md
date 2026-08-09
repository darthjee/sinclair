# Architecture

## Overview

Sinclair is a small, dependency-light Ruby gem (built on top of `active_support`) whose
core class, `Sinclair`, is a **method builder**: it collects method definitions
(from strings, blocks, or delegated calls) and, on `#build`, evaluates them onto a
target class as instance or class methods. Everything else in the gem is either a
supporting concern used by `Sinclair` itself, or a standalone module that other gems
can mix in independently (configuration, options parsing, env-var reading, model
generation, comparison, RSpec matchers).

All top-level constants are `autoload`ed from `lib/sinclair.rb`, so requiring `sinclair`
does not eagerly load the whole tree — each file under `lib/sinclair/` is only loaded
when its constant is first referenced.

## Source Code Layout

All application source code lives under `lib/sinclair/`, plus the entry point `lib/sinclair.rb`.

### `lib/sinclair.rb`

Defines the `Sinclair` class itself: `#initialize`, `#add_method`, `#add_class_method`,
`#eval_and_add_method`, and `#build`. Declares every `autoload` for the gem's public
constants and includes `OptionsParser` / extends `ClassMethods` (the `Sinclair.build`
class-level entry point).

### `method_definition/` and `method_definition.rb`

Represents a single method to be built. `MethodDefinition` dispatches to one of:
- `StringDefinition` — method body given as a code string.
- `BlockDefinition` — method body given as a block.
- `CallDefinition` — delegates to another method call (e.g. `attr_accessor`).

`ParameterBuilder`/`ParameterHelper` and `BlockHelper` support argument handling and
block evaluation; `Stringifier` turns definitions into evaluable code strings.
`MethodDefinitions` (plural, top-level file) is the collection object that `Sinclair`
uses to accumulate instance/class method definitions before building.

### `method_builder/` and `method_builder.rb`

Takes a `MethodDefinitions` collection and actually defines the methods on the target
class via `define_method`/`class_eval`. `Base` holds shared logic; `BlockMethodBuilder`,
`CallMethodBuilder`, and `StringMethodBuilder` handle each definition type.

### `options/`, `options.rb`, `options_parser.rb`

`Sinclair::Options` — a DSL (`Builder`, `ClassMethods`) for declaring structured,
validated option objects (used internally for `Sinclair`'s own `options` hash, and
usable standalone). `OptionsParser` is the concern `Sinclair` includes to expose
`options_object` inside builders/blocks.

### `config/`, `config.rb`, `config_builder.rb`, `config_class.rb`, `config_factory.rb`, `configurable.rb`

`Sinclair::Configurable` / `Sinclair::Config` — adds a `configure`/`config` pattern to
any class or module. `ConfigFactory` and `ConfigBuilder` build the backing `ConfigClass`;
`config/methods_builder.rb` wires the generated accessor methods.

### `settable/`, `settable.rb`, `env_settable.rb`, `chain_settable.rb`

`Sinclair::EnvSettable` — declares class methods that read from `ENV`, with type
casting. `Settable` is the shared engine (`Builder`, `Caster`, `ClassMethods`);
`ChainSettable` supports chaining multiple settable sources; `EnvSettable` is the
env-var-specific façade.

### `caster/`, `caster.rb`

Shared type-casting logic (`ClassMethods`) reused by both `Options` and `Settable` to
coerce raw input values (strings, env vars) into typed Ruby values.

### `model/`, `model.rb`

`Sinclair::Model` — helpers for quickly defining plain-Ruby model classes, either via
`initialize_with` in the class body (`BuilderOptions`, `Builder`) or via `.for` as an
inline subclassing helper.

### `comparable/`, `comparable.rb`, `equals_checker/`, `equals_checker.rb`

`Sinclair::Comparable` — mixin that implements `==` based on a declared list of
attributes. `EqualsChecker` (with `Reader`) does the actual attribute comparison.

### `matchers/`, `matchers.rb`

`Sinclair::Matchers` — RSpec matchers (`add_method`, `add_class_method`,
`add_instance_method`, `change_method`, `change_class_method`, `change_instance_method`,
and their `_to`/`_on` fluent variants) for asserting on `Sinclair`-based builders'
behavior in specs. `Base` holds shared matcher logic.

### `core_ext/`

Small core Ruby extensions (`Object`) used internally by the gem.

### `input_hash.rb`, `exception.rb`, `class_methods.rb`, `version.rb`

Supporting top-level files: `InputHash` (hash-input normalization), `Exception` (gem
error hierarchy), `ClassMethods` (`Sinclair.build`), `VERSION` (gem version constant).
