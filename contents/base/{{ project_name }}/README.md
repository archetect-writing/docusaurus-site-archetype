# {{ site_title }}

{{ site_tagline }}

Built with [Docusaurus](https://docusaurus.io/).

## Install

```bash
npm install
```

## Local Development

```bash
npm start
```

Starts a local dev server at http://localhost:3000 with hot reload.

## Build

```bash
npm run build
```

Generates static content into the `build/` directory.

## Typecheck

```bash
npm run typecheck
```

## Using pnpm?

Docusaurus is package-manager-agnostic. Substitute `pnpm` for `npm`:

```bash
pnpm install
pnpm start
pnpm build
pnpm typecheck
```

(If you use pnpm, commit `pnpm-lock.yaml` and delete `package-lock.json`.)
{% if deploy_target == "GitHub Pages" then %}

## Deploy

{% if is_root_domain then %}
Configured for GitHub Pages at `https://{{ project_name }}/` (root domain).
{% else %}
Configured for GitHub Pages at
`https://{{ organization }}.github.io/{{ project_name }}/`.
{% end %}
Push to `main` — the Actions workflow builds and publishes automatically.
{% elseif deploy_target == "Vercel" then %}

## Deploy

Connect this repository to [Vercel](https://vercel.com) — it will
auto-detect Docusaurus and deploy on every push.
{% elseif deploy_target == "Netlify" then %}

## Deploy

Connect this repository to [Netlify](https://netlify.com) — the included
`netlify.toml` configures the build.
{% end %}
