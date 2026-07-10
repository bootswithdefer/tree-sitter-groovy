# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This is the `bootswithdefer` fork of
[`murtaza64/tree-sitter-groovy`](https://github.com/murtaza64/tree-sitter-groovy),
extended to parse the full breadth of Groovy found in Jenkins pipelines,
shared pipeline libraries, and general Groovy source.

## [Unreleased]

## [0.1.0] - 2026-07-10

First versioned release of the fork. Parses 194/194 sample Jenkinsfiles and
79/79 shared pipeline-library files with zero errors. 138/138 corpus tests
pass with 100% named-node-type coverage (enforced in CI via prek).

### Added

- Destructuring declarations (`def (a, b) = ...`) and tuple assignment (`(a, b) = ...`).
- Qualified types (`a.b.C`) and juxtaposition-as-expression support.
- Closure method chaining and closures in `dotted_identifier` start position.
- Cast expressions, enhanced for-loops (`for (char c : arr)`), explicit generic
  method invocation (`Collections.<T>method()`), and line continuation (`\`).
- `assert` with a message, in both `assert cond, msg` and `assert cond : msg` forms.
- Annotation named arguments (`@Foo(bar = 1)`), spread-map entries (`*: m`),
  and varargs parameters (`String... args`).
- `object_creation` rule: `new Type()`, `new Type<G>()`, diamond `new Type<>()`,
  lowercase constructor names (`new my_params()`), and arrays (`new int[n]`).
- Parenthesized lambdas (`(a, b) -> expr`, `() -> expr`) and bare lambdas
  (`x -> expr`) in argument position.
- Method definitions without an explicit return type (`private foo() {}`) and
  generic method type parameters (`<T> void f(...)`).
- Generics accepting type-parameter names and wildcards: `List<T>`, `Map<K, V>`, `List<?>`.
- `class ... implements` clause (multiple interfaces), including `abstract` classes.
- Additional modifiers: `volatile`, `transient`, `abstract`, `native`, `strictfp`.
- Jenkinsfile-specific and general-Groovy test corpora.
- `scripts/coverage.sh` enforcing 100% named-node-type coverage, wired into prek.

### Fixed

- Closure parameter vs. declaration ambiguity (`{ a -> ... }` parses as a closure
  with parameter `a`, not a nested lambda).
- `juxt_function_call` greedily consuming across newlines inside map values.
- Slashy-string (`/regex/`) handling and the `$/...$/` dollar-slashy ambiguity.
- Statements following a top-level `pipeline { }` block.

[Unreleased]: https://github.com/bootswithdefer/tree-sitter-groovy/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/bootswithdefer/tree-sitter-groovy/releases/tag/v0.1.0
