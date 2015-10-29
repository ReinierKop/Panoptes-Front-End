DEFAULT_ENV = 'staging'

API_HOSTS =
  production: 'https://www.zooniverse.org'
  staging: 'http://192.168.99.100:3000'
  cam: 'http://172.17.2.87:3000'

API_APPLICATION_IDS =
  production: 'f79cf5ea821bb161d8cbb52d061ab9a2321d7cb169007003af66b43f7b79ce2a'
  staging: 'aa59f72734cda998f263d033a8e11692eb035f218d3f4ed4a9e02a61a3f0e4ce'
  cam: '535759b966935c297be11913acee7a9ca17c025f9f15520e7504728e71110a27'

TALK_HOSTS =
  production: 'https://talk.zooniverse.org'
  staging: 'https://talk-staging.zooniverse.org'

SUGAR_HOSTS =
  production: 'https://notifications.zooniverse.org'
  staging: 'https://notifications-staging.zooniverse.org'

hostFromBrowser = location?.search.match(/\W?panoptes-api-host=([^&]+)/)?[1]
appFromBrowser = location?.search.match(/\W?panoptes-api-application=([^&]+)/)?[1]
talkFromBrowser = location?.search.match(/\W?talk-host=([^&]+)/)?[1]
sugarFromBrowser = location?.search.match(/\W?sugar-host=([^&]+)/)?[1]

hostFromShell = process.env.PANOPTES_API_HOST
appFromShell = process.env.PANOPTES_API_APPLICATION
talkFromShell = process.env.TALK_HOST
sugarFromShell = process.env.SUGAR_HOST

envFromBrowser = location?.search.match(/\W?env=(\w+)/)?[1]
envFromShell = process.env.NODE_ENV

env = envFromBrowser ? envFromShell ? DEFAULT_ENV
env = DEFAULT_ENV

module.exports =
  host: API_HOSTS[env]
  clientAppID: API_APPLICATION_IDS[env]
  talkHost: TALK_HOSTS[env]
  sugarHost: SUGAR_HOSTS[env]
