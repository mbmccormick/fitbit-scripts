local CONSUMER_KEY = 'Fitbit Consumer Key'
local CONSUMER_SECRET = 'Fitbit Consumer Secret'

local ACCESS_TOKEN = storage.accesstoken or nil
local TOKEN_SECRET = storage.tokensecret or nil

local hour = tonumber(os.date('%H')) - 7

if (hour < 9 or -- 9:00am pacific time
    hour > 19) then -- 7:00pm pacific time
	storage.sedentaryMinutes = 0
	return
end

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

local percentage = math.floor(((data.summary.sedentaryMinutes - sedentaryMinutes) / minutes) * 10)
log(percentage)

if percentage > 60 then
	alert.sms('Wake up! You\'ve been sedentary for ' .. percentage .. '% of the last 2 hours.')
end

storage.lastCheck = os.time()
storage.sedentaryMinutes = data.summary.sedentaryMinutes
