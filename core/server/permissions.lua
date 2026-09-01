local DB = require('server.db') -- this will load the DB wrapper
local Permissions = {}

-- get member rank
function Permissions.getMemberRank(factionId, identifier, cb)
  DB.fetch("SELECT fm.id as member_id, fm.rank_id, fr.name, fr.rank_order, fr.priority FROM faction_members fm LEFT JOIN faction_ranks fr ON fm.rank_id = fr.id WHERE fm.faction_id = ? AND fm.identifier = ?", {factionId, identifier}, function(rows)
    if rows and #rows > 0 then cb(rows[1]) else cb(nil) end
  end)
end

function Permissions.hasPermission(factionId, identifier, permissionKey, cb)
  Permissions.getMemberRank(factionId, identifier, function(rank)
    if not rank or not rank.rank_id then cb(false) return end
    DB.fetch("SELECT allowed FROM faction_permissions WHERE faction_id = ? AND rank_id = ? AND permission_key = ?", {factionId, rank.rank_id, permissionKey}, function(rows)
      if rows and #rows > 0 and tonumber(rows[1].allowed) == 1 then cb(true) else cb(false) end
    end)
  end)
end

function Permissions.isLeader(factionId, identifier, cb)
  DB.fetch("SELECT head_identifier FROM factions WHERE id = ?", {factionId}, function(rows)
    if rows and #rows > 0 and rows[1].head_identifier == identifier then cb(true) else cb(false) end
  end)
end

return Permissions
