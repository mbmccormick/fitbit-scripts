local CONSUMER_KEY = 'Fitbit Consumer Key'
local CONSUMER_SECRET = 'Fitbit Consumer Secret'

local ACCESS_TOKEN = storage.accesstoken or nil
local TOKEN_SECRET = storage.tokensecret or nil

local date = os.date('%Y') .. '-' .. os.date('%m') .. '-' .. os.date('%d')

function check_battery()
  local response = http.request {
		url = 'http://api.fitbit.com/1/user/-/devices.json',
		auth = {
			oauth = {
				consumertoken = CONSUMER_KEY,
				consumersecret = CONSUMER_SECRET,
				accesstoken = ACCESS_TOKEN,
				tokensecret = TOKEN_SECRET
			}
		}
	}
	
	local data = json.parse(response.content)
	
	for key, value in pairs(data) do
		if value.battery == 'Low' then
			alert.email('Your Fitbit ' .. value.deviceVersion .. ' has a low battery.')
		end
	end
end

function get_summary()
	local response = http.request {
		url = 'http://api.fitbit.com/1/user/-/activities/date/' .. date .. '.json',
		auth = {
			oauth = {
				consumertoken = CONSUMER_KEY,
				consumersecret = CONSUMER_SECRET,
				accesstoken = ACCESS_TOKEN,
				tokensecret = TOKEN_SECRET
			}
		}
	}
	
	local data = json.parse(response.content)
	
	return 'steps: ' .. data.summary.steps .. '\n' ..
		'veryActiveMinutes: ' .. data.summary.veryActiveMinutes .. '\n' ..
		'fairlyActiveMinutes: ' .. data.summary.fairlyActiveMinutes .. '\n' ..
		'lightlyActiveMinutes: ' .. data.summary.lightlyActiveMinutes .. '\n' ..
		'sedentaryMinutes: ' .. data.summary.sedentaryMinutes .. '\n'
end

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

check_battery()

return get_summary()
