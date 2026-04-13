-- Tutorial archetype — demonstrates the core v3 Lua scripting features.
-- Each section is commented to explain what it does and why. Enable or
-- disable sections as you adapt this for your real archetype.

local context = Context.new()

-- ──────────────────────────────────────────────────────────────────────
-- 1. Text prompt with case-variant expansion
--
-- `Cases.programming()` expands the input into snake/pascal/camel/kebab/
-- train/constant variants. The key names are derived from the primary
-- key by applying the case transform to the KEY itself, so for
-- `project_name` you get:
--
--   project_name      snake value (OVERWRITES the original!)
--   ProjectName       pascal value
--   projectName       camel value
--   project-name      kebab value   (use ctx:get("project-name"))
--   Project-Name      train value
--   PROJECT_NAME      constant value
--
-- The snake variant overwriting the primary key is a footgun — if the
-- user types "my-cool-project", `project_name` ends up as "my_cool_project".
-- Retrieve the kebab form explicitly when you need to preserve the
-- user's original hyphenated input.
-- ──────────────────────────────────────────────────────────────────────

context:prompt_text("Project Name:", "project_name", {
    cases = { Cases.programming(), Cases.input("project_name_input") },
    help = "Type any case; programming-case variants are generated. The original input is preserved as project_name_input.",
})

-- ──────────────────────────────────────────────────────────────────────
-- 2. Multi-select prompt with a default
-- ──────────────────────────────────────────────────────────────────────

context:prompt_multi_select("Target Platforms:", "platforms",
    { "linux-amd64", "linux-arm64", "darwin-arm64", "windows-amd64" },
    { default = { "linux-amd64", "darwin-arm64" } })

-- ──────────────────────────────────────────────────────────────────────
-- 3. Select from a fixed list
-- ──────────────────────────────────────────────────────────────────────

context:prompt_select("License:", "license",
    { "Apache-2.0", "MIT", "GPL-3.0", "None" },
    { default = "Apache-2.0" })

-- Author info is auto-populated from ~/.config/archetect/archetect.yaml
-- if you set `answers.author_full` there, but prompting picks it up.
context:prompt_text("Author:", "author_full", {
    placeholder = "Your Name <you@example.com>",
})

-- ──────────────────────────────────────────────────────────────────────
-- 4. Require a local helper module from `lib/`
--
-- v3 auto-discovers the archetype's own `lib/` directory and adds it
-- to Lua's package.path. This line loads `lib/helpers.lua`.
-- ──────────────────────────────────────────────────────────────────────

local helpers = require("helpers")
helpers.log_summary(context)

-- ──────────────────────────────────────────────────────────────────────
-- 5. Render templates
--
-- v3 auto-discovers the archetype's own `includes/` directory, so
-- templates under `contents/` can use {% include "file.atl" %}
-- without any manifest config.
-- ──────────────────────────────────────────────────────────────────────

directory.render("contents", context)
