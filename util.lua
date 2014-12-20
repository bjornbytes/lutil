----------------
-- Class
----------------
function new(x, ...)
  local t = extend(x)
  if t.init then
    t:init(...)
  end
  return t
end

function extend(x)
  local t = {}
  setmetatable(t, {__index = x, __call = new})
  return t
end

function class() return extend() end


----------------
-- Math
----------------
function math.sign(x) return x > 0 and 1 or x < 0 and -1 or 0 end
function math.round(x) return math.sign(x) >= 0 and math.floor(x + .5) or math.ceil(x - .5) end
function math.clamp(x, l, h) return math.min(math.max(x, l), h) end
function math.lerp(x1, x2, z) return x1 + (x2 - x1) * z end
function math.anglerp(d1, d2, z) return d1 + (math.anglediff(d1, d2) * z) end
function math.dx(len, dir) return len * math.cos(dir) end
function math.dy(len, dir) return len * math.sin(dir) end
function math.distance(x1, y1, x2, y2) return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ .5 end
function math.direction(x1, y1, x2, y2) return math.atan2(y2 - y1, x2 - x1) end
function math.vector(...) return math.distance(...), math.direction(...) end
function math.inside(px, py, rx, ry, rw, rh) return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh end
function math.anglediff(d1, d2) return math.rad((((math.deg(d2) - math.deg(d1) % 360) + 540) % 360) - 180) end


----------------
-- Table
----------------
all = pairs
function table.eq(t1, t2)
  if type(t1) ~= type(t2) then return false end
  if type(t1) ~= 'table' then return t1 == t2 end
  if #t1 ~= #t2 then return false end
  for k, _ in pairs(t1) do
    if not table.eq(t1[k], t2[k]) then return false end
  end
  return true
end

function table.copy(x)
  local t = type(x)
  if t ~= 'table' then return x end
  local y = {}
  for k, v in next, x, nil do y[k] = table.copy(v) end
  setmetatable(y, getmetatable(x))
  return y
end

function table.has(t, x, deep)
  local f = deep and table.eq or rawequal
  for _, v in pairs(t) do if f(v, x) then return true end end
  return false
end

function table.only(t, ks)
  local res = {}
  for _, k in pairs(ks) do res[k] = t[k] end
  return res
end

function table.except(t, ks)
  local res = table.copy(t)
  for _, k in pairs(ks) do res[k] = nil end
  return res
end

function table.keys(t)
  local res = {}
  table.each(t, function(_, k) table.insert(res, k) end)
  return res
end

function table.values(t)
  local res = {}
  table.each(t, function(v) table.insert(res, v) end)
  return res
end

function table.take(t, n)
  local res = {}
  for i = 1, n do res[i] = t[i] end
  return res
end

function table.drop(t, n)
  local res = table.copy(t)
  for i = 1, n do table.remove(t, 1) end
  return res
end

function table.each(t, f)
  if not t then return end
  for k, v in pairs(t) do if f(v, k) then break end end
end

function table.with(t, k, ...)
  return table.each(t, f.egoexe(k, ...))
end

function table.map(t, f)
  if not t then return end
  local res = {}
  table.each(t, function(v, k) res[k] = f(v, k) end)
  return res
end

function table.filter(t, f)
  return table.map(t, function(v, k) return f(v, k) and v or nil end)
end

function table.clear(t, v)
  table.each(t, function(_, k) t[k] = v end)
end

function table.merge(t1, t2, shallow)
  t1, t2 = t1 or {}, t2 or {}
  for k, v in pairs(t1) do t2[k] = shallow and v or table.copy(v) end
  return t2
end

function table.deltas(t1, t2)
  local res = {}
  for k, v in pairs(t1) do
    if type(t1[k]) ~= type(t2[k]) then
      res[k] = type(t2[k]) == 'table' and table.copy(t2[k]) or t2[k]
    elseif type(t2[k]) == 'table' then
      res[k] = table.deltas(t1[k], t2[k])
    elseif t1[k] ~= t2[k] then
      res[k] = t2[k]
    end
  end
  
  return res
end

function table.interpolate(t1, t2, z)
  local interp = table.copy(t1)
  for k, v in pairs(interp) do
    if t2[k] then
      if type(v) == 'table' then interp[k] = table.interpolate(t1[k], t2[k], z)
      elseif type(v) == 'number' then
        if k == 'angle' then interp[k] = math.anglerp(t1[k], t2[k], z)
        else interp[k] = math.lerp(t1[k], t2[k], z) end
      end
    end
  end
  return interp
end

function table.shuffle(t)
  for i = 1, #t do
    local a, b = math.random(#t), math.random(#t)
    t[a], t[b] = t[b], t[a]
  end
end

function table.count(t)
  local ct = 0
  table.each(t, function() ct = ct + 1 end)
  return ct
end

function table.print(t, n)
  n = n or 0
  if n > 10 then return end
  if t == nil then print('nil') end
  if type(t) ~= 'table' then io.write(tostring(t)) io.write('\n')
  else
    local empty = true
    for k, v in pairs(t) do
      empty = false
      io.write(string.rep('\t', n))
      io.write(k)
      if type(v) == 'table' then io.write('\n')
      else io.write('\t') end
      table.print(v, n + 1)
    end
    if empty then io.write(string.rep('\t', n) .. '{}\n') end
  end
end


----------------
-- Functions
----------------
f = {}
f.empty = function() end
f.exe = function(x, ...) if type(x) == 'function' then return x(...) end return x end
f.ego = function(f, ...) local a = {...} return function(x) x[f](x, unpack(a)) end end
f.egoexe = function(f, ...) local a = {...} return function(x) if x[f] then x[f](x, unpack(a)) end end end
f.val = function(x) return type(x) == 'function' and x or function() return x end end
f.cur = function(fn, x) return function(y) return fn(x, y) end end
f.wrap = function(fn, ...) local a = {...} return function() fn(unpack(a)) end end


----------------
-- String
----------------
string.capitalize = function(s) s = ' ' .. s return s:gsub('(%s%l)', string.upper):sub(2) end
