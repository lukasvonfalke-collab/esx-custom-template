-- Core: Dynamic Faction System (ESX + oxmysql)
-- server-side DB helper using oxmysql exports

local DB = {}

function DB.fetch(query, params, cb)
  params = params or {}
  exports.oxmysql:execute(query, params, function(result)
    if cb then cb(result) end
  end)
end

function DB.execute(query, params, cb)
  params = params or {}
  exports.oxmysql:execute(query, params, function(affected)
    if cb then cb(affected) end
  end)
end

function DB.insert(query, params, cb)
  params = params or {}
  -- oxmysql returns affected rows, not always last insert. Use SELECT LAST_INSERT_ID() if needed
  exports.oxmysql:execute(query, params, function(res)
    if cb then cb(res) end
  end)
end

return DB
