# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Changed

- Package renamed to `@noflo/markdown`; the version resets to the 2.x generation (2.0.0-alpha.1) for the fresh package name. Component addressing is unchanged — library IDs derive identically from the scoped name, so component and graph names stay the same. The old `noflo-markdown` will be deprecated with a pointer once 2.x reaches stable
- Migrated to NoFlo 2.x: components now depend on `@noflo/noflo` ^2.0.0 instead of the unscoped `noflo` 1.x package; components export a named `getComponent`
- Package is now plain ESM with no build step; supported runtime is Node.js >= 22 (components also run under Deno and Bun); indentation normalized to spaces per the repository EditorConfig
- `markdown/ToMarkdown` uses turndown instead of the unmaintained html2commonmark, removing the jsdom dependency and the browser/node converter split. Conversion output differs from 1.x in formatting details (turndown's HTML traversal), and the output no longer carries a trailing newline
- Components report failures on the `error` port with `output.error()` instead of throwing inside the process function

### Added

- `test/` node:test suite covering both components and the error path
- Publish-time `noflo.json` component manifest
