-----------------------------------------------------------------------------------
-- HTTP Accept-Language header handler                                           --
-- @originalAuthor: f.ghibellini@gmail.com                                       --
-- @originalRepository: https://github.com/fghibellini/nginx-http-accept-lang    --
-- @modifiedBy: marian.hello@mapilary.com                                        --
-- @gist: https://gist.github.com/mauron85/47ed1075262d9e020fe2                  --
-- @modifiedBy: lienhart.woitok@netlogix.de                                      --
-- @license: MIT                                                                 --
-- @requires:                                                                    --
-- @description:                                                                 --
--     returns accept header with only supported types ordered by priority       --
--     according to RFC:2616                                                     --
-- @example configuration:                                                       --
--                                                                               --
--     server {                                                                  --
--         listen 8080 default_server;                                           --
--         index index.html index.htm;                                           --
--         server_name localhost;                                                --
--                                                                               --
--         root usr/share/nginx/html;                                            --
--                                                                               --
--         location = / {                                                        --
--             # $accept_sup holds comma separated mime types supported by site  --
--             # if no match */* will be used. */*;q=0.8 will be appended.       --
--             set $accept_sup = "text/html,image/webp"                          --
--             set_by_lua_file $parsed_accept /etc/nginx/accept.lua $accept_sup; --
--             proxy_set_header Accept $parsed_accept;                           --
--         }                                                                     --
--     }                                                                         --
--                                                                               --
-----------------------------------------------------------------------------------

function inTable(tbl, item)
	for key, value in pairs(tbl) do
		if value == item then
			return key
		end
	end
	return false
end

function string:split( inSplitPattern, outResults )
	if not outResults then
		outResults = { }
	end
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end

local supportedMimeTypes = {}
if ( ngx.arg[1] ~= nil ) then
	supportedMimeTypes = ngx.arg[1]:split(",")
end

local acceptHeader = ngx.var.http_accept
if ( acceptHeader == nil ) then
	return supportedMimeTypes[1]
end

local cleaned = ngx.re.sub(acceptHeader, "^.*:", "")
local options = {}
local iterator, err = ngx.re.gmatch(cleaned, "\\s*([a-z]+/(?:[a-z0-9+-]+|\\*)|\\*/\\*)\\s*(?:;q=([0-9]+(?:.[0-9]*)?))?\\s*(?:,|$)", "i")
for m, err in iterator do
	local mimeType = m[1]
	local priority = 1
	if m[2] ~= nil then
		priority = tonumber(m[2])
		if priority == nil then
			priority = 1
		end
	end
	table.insert(options, {mimeType, priority})
end

table.sort(options, function(a,b) return b[2] < a[2] end)

local result = {}

for index, mimeType in pairs(options) do
	if inTable(supportedMimeTypes, mimeType[1]) then
		table.insert(result, mimeType[1])
	end
end

if #result == 0 then
	return "*/*"
end

table.insert(result, "*/*;q=0.8")
return table.concat(result, ",")
