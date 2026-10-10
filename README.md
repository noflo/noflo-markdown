# noflo-markdown — Markdown conversion for NoFlo

Markdown conversion components for [NoFlo](https://noflojs.org): Markdown to HTML via the CommonMark reference parser, and HTML to Markdown.

Part of the NoFlo 2.x component library family. Requires Node.js >= 22, and runs on Deno and Bun as well. All components are isomorphic.

## Usage

    npm install @noflo/markdown

Component identifiers in graphs are `markdown/<Component>`, for example `markdown/ParseMarkdown`. See `noflo.json` for the machine-readable component manifest.

## Components

- **markdown/ParseMarkdown** — converts a Markdown string to HTML (CommonMark reference parser)
- **markdown/ToMarkdown** — converts an HTML string to Markdown (turndown); `iframe`, `article`, `video`, and `table` elements are kept as raw HTML

## Development

    npm test

The test suite runs TypeScript checks, Biome lint, fbp-spec cases from `spec/`, and `node:test` suites from `test/`.

## License

MIT
