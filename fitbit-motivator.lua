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

local lastCheck = storage.lastCheck or os.time()
local sedentaryMinutes = storage.sedentaryMinutes or 0

local minutes = tonumber(os.time() - lastCheck) / 60

if (data.summary.sedentaryMinutes - sedentaryMinutes) / minutes > 0.75 then
	local alarmTime = os.date('%H') .. ':' .. os.date('%M', os.time() + 600)
	
	local response = http.request {
		url = 'http://api.fitbit.com/1/user/-/devices/tracker/1420941/alarms.json',
		auth = {
			oauth = {
				consumertoken = CONSUMER_KEY,
				consumersecret = CONSUMER_SECRET,
				accesstoken = ACCESS_TOKEN,
				tokensecret = TOKEN_SECRET
			}
		},
		data = { 
			time = alarmTime .. '+00:00',
			enabled = 'true',
			recurring = 'false',
			weekDays = 'none',
			label = 'WAKE UP',
			snoozeLength = '5',
			snoozeCount = '1',
			vibe = 'DEFAULT'
		}
	}
end

storage.lastCheck = os.time()
storage.sedentaryMinutes = data.summary.sedentaryMinutes
