-- Example helper module, auto-discovered by archetect's local `lib/`
-- convention. Reachable from archetype.lua as `require("helpers")`.

local M = {}

function M.log_summary(context)
    log.info("── Project summary ──")
    log.info("Name     : " .. (context:get("project-name") or context:get("project_name") or "unknown"))
    log.info("License  : " .. (context:get("license") or "none"))

    local platforms = context:get("platforms") or {}
    log.info("Platforms: " .. table.concat(platforms, ", "))
end

return M
