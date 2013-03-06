local CONSUMER_KEY = 'Fitbit Consumer Key'
local CONSUMER_SECRET = 'Fitbit Consumer Secret'
 
-- get a request token
local response = http.request {
  url = 'http://api.fitbit.com/oauth/request_token',
	params = { 
		oauth_callback = 'http://matt.webscript.io/fitbit-callback'
	},
	auth = {
		oauth = {
			consumertoken = CONSUMER_KEY,
			consumersecret = CONSUMER_SECRET
		}
	}
}
 
local token = http.qsparse(response.content)
 
-- store the token secret in storage
storage['secret:' .. token.oauth_token] = token.oauth_token_secret
 
-- redirect user to login page
return 302, '', {
	Location = 'http://www.fitbit.com/oauth/authorize?oauth_token=' .. token.oauth_token
}
