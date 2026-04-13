-- Docusaurus Site Archetype
--
-- Scaffolds a modern TypeScript Docusaurus 3 site with a composable
-- overlay tree:
--
--   contents/base/                 -- always rendered (minimal scaffold)
--   contents/preset-standard/      -- + Docusaurus tutorial content
--   contents/preset-archetect-style/  -- + concepts/guides/reference docs
--   contents/deploy-github-pages/  -- + .github/workflows/deploy.yml
--   contents/deploy-vercel/        -- + vercel.json
--   contents/deploy-netlify/       -- + netlify.toml
--   contents/extras-blog/          -- + blog/ dir
--   contents/extras-versioned-docs/-- + versioned_docs scaffold
--   contents/github/               -- + release workflow, version-line

local context = Context.new()

-- ─── Site identity ───────────────────────────────────────────────────
context:prompt_text("Site Title:", "site_title", {
    placeholder = "My Documentation",
    help = "Human-readable name shown in the browser tab and navbar.",
})

context:prompt_text("Site Tagline:", "site_tagline", {
    default = "Documentation built with Docusaurus",
    help = "One-line description shown on the homepage hero.",
})

context:prompt_text("Project Name:", "project_name", {
    placeholder = "my-docs",
    help = "Used as the repo/folder name. kebab-case. Will also be the GitHub Pages baseUrl.",
    cases = { Cases.input("project_name_input") },
})

-- Ensure kebab-case for project_name regardless of input casing
context:set("project_name", Case.Kebab:apply(context:get("project_name")))

-- ─── Deployment target ───────────────────────────────────────────────
context:prompt_select("Deploy Target:", "deploy_target",
    { "GitHub Pages", "Vercel", "Netlify", "None" },
    {
        default = "GitHub Pages",
        help = "GitHub Pages wires up a deploy Action. Vercel/Netlify add config files. None skips deploy wiring.",
    })

-- ─── Content preset ──────────────────────────────────────────────────
context:prompt_select("Content Preset:", "content_preset",
    { "minimal", "standard", "archetect-style" },
    {
        default = "standard",
        help = "minimal = bare scaffold (intro + homepage). standard = Docusaurus tutorial docs, homepage features, example blog posts. archetect-style = empty Intro/Concepts/Guides/Reference sections ready to fill.",
    })

-- ─── Extras ──────────────────────────────────────────────────────────
context:prompt_multi_select("Extras:", "extras",
    { "Mermaid", "Local Search", "Dark Mode Default", "Versioned Docs", "Blog" },
    {
        default = { "Mermaid", "Local Search" },
        help = "Mermaid = diagram support. Local Search = offline full-text search. Dark Mode = default to dark. Versioned Docs = docs/versioning scaffold. Blog = enable /blog section.",
    })

-- Derive per-extra booleans for template use
local extras = context:get("extras") or {}
local function has(list, name)
    for _, v in ipairs(list) do if v == name then return true end end
    return false
end
context:set("extras_mermaid", has(extras, "Mermaid"))
context:set("extras_search", has(extras, "Local Search"))
context:set("extras_dark_default", has(extras, "Dark Mode Default"))
context:set("extras_versioned_docs", has(extras, "Versioned Docs"))
context:set("extras_blog", has(extras, "Blog"))

-- ─── Source control ──────────────────────────────────────────────────
context:prompt_select("Source Control:", "scm_provider",
    { "None", "GitHub (Instructions)", "GitHub (Publish)" },
    {
        default = "GitHub (Instructions)",
        help = "Publish requires GITHUB_TOKEN. Instructions prints the commands you need to run manually.",
    })

local scm = context:get("scm_provider")
local uses_github = scm == "GitHub (Instructions)" or scm == "GitHub (Publish)"
context:set("scm_uses_github", uses_github)

if uses_github then
    context:prompt_text("GitHub Organization:", "organization", {
        placeholder = "your-org",
        default = "your-org",
    })
else
    context:set("organization", "your-org")
end

-- GITHUB_TOKEN pre-check
if scm == "GitHub (Publish)" then
    local token = os.getenv("GITHUB_TOKEN")
    if not token or token == "" then
        log.warn("GITHUB_TOKEN is not set. Falling back to GitHub (Instructions) mode.")
        scm = "GitHub (Instructions)"
        context:set("scm_provider", scm)
    end
end

local project_name = context:get("project_name")
context:set("github_slug", uses_github and (context:get("organization") .. "/" .. project_name) or "")

-- ─── Render ──────────────────────────────────────────────────────────
-- Always render the base.
directory.render("contents/base", context)

-- Content preset overlays (additive / overwriting).
local preset = context:get("content_preset")
if preset == "standard" then
    directory.render("contents/preset-standard", context, { if_exists = Existing.Overwrite })
elseif preset == "archetect-style" then
    directory.render("contents/preset-archetect-style", context, { if_exists = Existing.Overwrite })
end

-- Deploy overlays.
local deploy = context:get("deploy_target")
if deploy == "GitHub Pages" then
    directory.render("contents/deploy-github-pages", context)
elseif deploy == "Vercel" then
    directory.render("contents/deploy-vercel", context)
elseif deploy == "Netlify" then
    directory.render("contents/deploy-netlify", context)
end

-- Extras overlays.
if context:get("extras_blog") then
    directory.render("contents/extras-blog", context)
end
if context:get("extras_versioned_docs") then
    directory.render("contents/extras-versioned-docs", context)
end

-- SCM wiring.
if uses_github then
    directory.render("contents/github", context)
end

-- ─── git init + initial commit ───────────────────────────────────────
local git = require("archetect.git")
local repo = git.init(project_name, { branch = "main" })
repo:add_all()
repo:commit("initial commit")

-- ─── Publish or instructions ─────────────────────────────────────────
if scm == "GitHub (Publish)" then
    local github = require("archetect.github")
    local slug = context:get("github_slug")
    if github.create_repo(slug, { visibility = "public" }) then
        repo:remote_add("origin", "git@github.com:" .. slug .. ".git")
        repo:push("origin", "main")
        log.info("Published to https://github.com/" .. slug)
    else
        log.warn("Repository creation failed — push manually once resolved.")
    end
elseif scm == "GitHub (Instructions)" then
    local slug = context:get("github_slug")
    log.info("")
    log.info("Next steps:")
    log.info("  cd " .. project_name)
    log.info("  npm install")
    log.info("  npm start")
    log.info("")
    log.info("To publish to GitHub:")
    log.info("  gh repo create " .. slug .. " --public --source=. --remote=origin")
    log.info("  git push -u origin main")
    log.info("")
else
    log.info("")
    log.info("Local site created at ./" .. project_name)
    log.info("Run: cd " .. project_name .. " && npm install && npm start")
    log.info("")
end
