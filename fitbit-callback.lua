local CONSUMER_KEY = 'Fitbit Consumer Key'
local CONSUMER_SECRET = 'Fitbit Consumer Secret'

local ACCESS_TOKEN = storage.accesstoken or nil
local TOKEN_SECRET = storage.tokensecret or nil

if ACCESS_TOKEN == nil and TOKEN_SECRET == nil then
	local response = http.request {
		url = 'http://api.fitbit.com/oauth/access_token',
		auth = {
			oauth = {
				consumertoken = CONSUMER_KEY,
				consumersecret = CONSUMER_SECRET,
				accesstoken = request.query.oauth_token,
				tokensecret = storage['secret:' .. request.query.oauth_token],
				verifier = request.query.oauth_verifier
			}
		}
	}
	
	local ret = http.qsparse(response.content)
	
	storage['secret:' .. request.query.oauth_token] = nil

	ACCESS_TOKEN = ret.oauth_token
	TOKEN_SECRET = ret.oauth_token_secret
	
	storage.accesstoken = ACCESS_TOKEN
	storage.tokensecret = TOKEN_SECRET
end

return 'authentication succeeded'
