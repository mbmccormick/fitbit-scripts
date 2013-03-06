local CONSUMER_KEY = 'Fitbit Consumer Key'
local CONSUMER_SECRET = 'Fitbit Consumer Secret'

local ACCESS_TOKEN = storage.accesstoken or nil
local TOKEN_SECRET = storage.tokensecret or nil

local date = os.date('%Y') .. '-' .. os.date('%m') .. '-' .. os.date('%d')

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
