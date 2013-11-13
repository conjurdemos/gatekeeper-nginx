
-- We want to check that when a user requests a uri like
-- /fry/bacon that they have permission to "fry" a resource called
-- "service:bacon"

-- parse the request uri, reject requests not matching our pattern with 
-- 404.  Notice that with ngx.re.match we can use proper PCREs instead of 
-- lua regexes - fast and familiar!
local pattern = "^/(.+?)/(.+)$"
local match, err = ngx.re.match(ngx.var.uri, pattern)
if not match then 
  ngx.log(ngx.ERR, "uri " .. ngx.var.uri .. " did not match pattern")
  return ngx.exit(404)
end
-- extract the resource_id and privilege from the match
local privilege, resource_id = match[1], match[2]

-- use a configured account or the default (sandbox)
local account = ngx.var.conjur_account or 'sandbox';

-- build a location like /conjur/authz/sandbox/resources/nginx-demo-service/bacon?check&privilege=fry
local location = '/conjur/authz/' .. ngx.escape_uri(account) .. '/resources/'
location = location .. 'service/' .. ngx.escape_uri(resource_id)
location = location  .. '?check&privilege=' .. ngx.escape_uri(privilege)

-- capture the response
local response = ngx.location.capture(location)
local status = response.status

if status >= 300 then
  -- at this point we could just exit with the status but we'll be a little more interesting
  
  -- respond with 401 for 401 (no authorization header or an expired token or something)
  if status == 401 then
    return ngx.exit(401)
  end
  -- 403 and 404 both indicate that the user does not have permission to do something
  -- respond with 403 to both
  if status == 403 or status == 404 then
    return ngx.exit(403)
  end
  -- 500 for anything else, but log it
  ngx.log(ngx.ERR, "error checking permission: " .. response.status)
  return ngx.exit(500)
end

