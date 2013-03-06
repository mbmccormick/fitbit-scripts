local CONSUMER_KEY = 'Fitbit Consumer Key'
local CONSUMER_SECRET = 'Fitbit Consumer Secret'

local ACCESS_TOKEN = storage.accesstoken or nil
local TOKEN_SECRET = storage.tokensecret or nil

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
