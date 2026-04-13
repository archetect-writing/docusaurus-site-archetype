{% include "license-header.atl" %}

# {{ project-name }}

A project scaffolded from `docusaurus-site-archetype`.

## Case variants

The `cases = Cases.programming()` option generates these derived keys:

- `{{ project-name }}` — kebab (canonical, preserves hyphens)
- `{{ project_name }}` — snake (overwrites primary key)
- `{{ ProjectName }}` — pascal
- `{{ projectName }}` — camel
- `{{ PROJECT_NAME }}` — constant

Use `Cases.input("project_name_input")` to preserve the original:

- `{{ project_name_input }}` — untransformed user input

## Target platforms

{% for platform in platforms %}
- {{ platform }}
{% end %}

## License

{{ license }}
