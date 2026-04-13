# docusaurus-site-archetype

Scaffolds a modern **Docusaurus 3** documentation site in TypeScript,
with opinionated defaults and a composable overlay tree — Archetect v3
native.

## Usage

```sh
# Interactive
archetect render https://github.com/archetect-writing/docusaurus-site-archetype.git

# Non-interactive, all defaults
archetect render https://github.com/archetect-writing/docusaurus-site-archetype.git \
    --dest /path/to/parent -D

# Non-interactive with explicit answers
archetect render https://github.com/archetect-writing/docusaurus-site-archetype.git \
    --dest /path/to/parent \
    -a site_title="Archetect Docs" \
    -a site_tagline="Language-agnostic code generator" \
    -a project_name="archetect-docs" \
    -a deploy_target="GitHub Pages" \
    -a content_preset=archetect-style \
    -a 'extras=["Mermaid","Local Search","Dark Mode Default"]' \
    -a scm_provider="GitHub (Instructions)" \
    -a organization=archetect
```

## Prompts

| Prompt | Key | Notes |
|---|---|---|
| Site Title | `site_title` | Shown in browser tab, navbar, homepage hero |
| Site Tagline | `site_tagline` | One-line description on homepage |
| Project Name | `project_name` | kebab-case; repo name + GitHub Pages `baseUrl` |
| Deploy Target | `deploy_target` | `GitHub Pages`, `Vercel`, `Netlify`, `None` |
| Content Preset | `content_preset` | `minimal`, `standard`, `archetect-style` |
| Extras | `extras` | Multi-select: Mermaid, Local Search, Dark Mode Default, Versioned Docs, Blog |
| Source Control | `scm_provider` | `None`, `GitHub (Instructions)`, `GitHub (Publish)` |
| GitHub Organization | `organization` | Only prompted if SCM starts with GitHub |

## Content presets

- **minimal** — bare scaffold: Docusaurus config, a homepage, a single
  `docs/intro.mdx`. No tutorial content, no features showcase.
- **standard** — minimal plus the stock Docusaurus tutorial docs, the
  three-card HomepageFeatures component, and three example blog posts
  (if Blog extra is selected). Good starting point if you want to learn
  Docusaurus by reading the scaffolded files.
- **archetect-style** — minimal plus an Intro / Concepts / Guides /
  Reference documentation structure, ready to fill. Opinionated for
  technical product docs.

## Deploy targets

- **GitHub Pages** — adds `.github/workflows/deploy.yml` that publishes
  `build/` on every push to `main`. Sets `url` + `baseUrl` to
  `https://<org>.github.io/<project>/`.
- **Vercel** — adds `vercel.json`. Connect the repo to Vercel and push
  to deploy.
- **Netlify** — adds `netlify.toml` with build + publish + SPA redirect.
- **None** — no deploy wiring.

## Extras

Selectable independently:

- **Mermaid** — enables `@docusaurus/theme-mermaid` so you can render
  diagrams in code fences.
- **Local Search** — adds `@easyops-cn/docusaurus-search-local`, offline
  full-text search, no Algolia required.
- **Dark Mode Default** — makes dark mode the default (users can still
  toggle).
- **Versioned Docs** — creates `versioned_docs/version-1.0/` and
  `versions.json` so you can version docs from day one.
- **Blog** — enables the `/blog` section with a working feed.

## Source control

- **None** — `git init` + initial commit, nothing more.
- **GitHub (Instructions)** — adds `.version-line` +
  `.github/workflows/release.yaml` wired to
  [`archetect-actions/repository-release`](https://github.com/archetect-actions/repository-release).
  Prints the exact `gh repo create` + `git push` commands.
- **GitHub (Publish)** — same as Instructions, plus calls
  `github.create_repo` and pushes `main` automatically. Requires
  `GITHUB_TOKEN`. Falls back to Instructions mode if the token is
  missing.

## Layout

```
contents/
├── base/                      # always rendered
├── preset-standard/           # + tutorial docs, HomepageFeatures
├── preset-archetect-style/    # + concepts/guides/reference
├── deploy-github-pages/       # + .github/workflows/deploy.yml
├── deploy-vercel/             # + vercel.json
├── deploy-netlify/            # + netlify.toml
├── extras-blog/               # + blog/
├── extras-versioned-docs/     # + versioned_docs, versions.json
└── github/                    # + release workflow, .version-line
```

Each overlay wraps its contents in `{{ project_name }}/` so the final
output lives in a single project-named subdirectory.

## After scaffolding

```bash
cd <project_name>
npm install
npm start
```

The site runs at <http://localhost:3000>.
