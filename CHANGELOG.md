# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

This is the `bootswithdefer` fork of
[`murtaza64/tree-sitter-groovy`](https://github.com/murtaza64/tree-sitter-groovy),
extended to parse the full breadth of Groovy found in Jenkins pipelines,
shared pipeline libraries, and general Groovy source.

## [Unreleased]

### Changed

- Renamed the npm package to `@bootswithdefer/tree-sitter-groovy` (the fork's
  own scope; it previously still carried the upstream `@murtaza64` scope and
  could not be published from this fork).
- Rewrote `.github/workflows/publish.yml` to publish via npm **OIDC trusted
  publishing** (no stored `NPM_TOKEN`, provenance attached), triggered on `v*`
  tags — consistent with `prettier-plugin-jenkinsfile`. The package is
  published source-only; consumers build the native binding on install via
  `node-gyp-build`.

## [0.2.0] - 2026-07-11

Robustness pass over real-world Jenkinsfiles: 181/182 sampled remote-repo
Jenkinsfiles now parse with zero errors (the one holdout is a non-Groovy
edge case). 139/139 corpus tests pass with 100% named-node-type coverage.

### Added

- `named_argument` — assignment-style named arguments in calls, e.g.
  `runAlembic(applyOnBranch=mainBranch)`.
- Capitalized / mixed-case identifiers (type-shaped names such as
  `TF_VAR_git_hash`) are now accepted as assignment targets, so
  `TF_VAR_x = readFile "..."` parses instead of mis-parsing as a declaration.

### Changed

- `groovy_doc` is now a single permissive token matching any `/** ... */`
  block. The previous rule (mandatory first-line + `@param`/`@throws`
  sub-parsing) failed on common groovydoc like `/** hi **/`, and — because
  `groovy_doc` is an `extra` — that turned into a whole-file parse error.
  Groovydoc now parses robustly for arbitrary content.
- `queries/highlights.scm` updated to capture the single `(groovy_doc)` node
  (dropped the now-nonexistent sub-node captures).
- Test corpus reorganized: general-Groovy cases moved out of
  `test/corpus/jenkinsfile.test` into topical files (`declaration`, `closure`,
  `annotation`, `for`, `each`, `map`, `list`, `string`, `comment`,
  `general_groovy`). `jenkinsfile.test` now holds only Jenkinsfile-specific
  tests.

### Removed

- `groovy_doc_param`, `groovy_doc_throws`, `groovy_doc_tag`,
  `groovy_doc_at_text`, and `first_line` node types, which are no longer
  produced now that `groovy_doc` is a token. Consumers querying these node
  types must update to `(groovy_doc)`.

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

[Unreleased]: https://github.com/bootswithdefer/tree-sitter-groovy/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/bootswithdefer/tree-sitter-groovy/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/bootswithdefer/tree-sitter-groovy/releases/tag/v0.1.0
