require 'openid'
require 'openid/store/filesystem'

OpenID.fetcher.timeout = 6

Rails.application.config.middleware.use OmniAuth::Builder do
  ssl_client_options = {}

  if SETTINGS['ssl_ca_path'].present?
    ssl_client_options = {:client_options => {:ssl => {:ca_path => SETTINGS['ssl_ca_path']}}}
  end

  provider(:twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'], ssl_client_options) if SETTINGS['providers'].include?('twitter')
  provider(:github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], ssl_client_options) if SETTINGS['providers'].include?('github')
  # provider(:google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], {access_type: 'online', approval_prompt: ''}.merge(ssl_client_options)) if SETTINGS['providers'].include?('google_oauth2')
  provider(:linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], {:scope => 'r_fullprofile r_emailaddress r_network', :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections"]}.merge(ssl_client_options)) if SETTINGS['providers'].include?('linkedin')
  provider(:facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], ssl_client_options) if SETTINGS['providers'].include?('facebook')
  # provider(:open_id, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'open_id') if SETTINGS['providers'].include?('open_id')

  # https://github.com/intridea/omniauth/issues/525
  # https://github.com/intridea/omniauth/blob/master/lib/omniauth/builder.rb
  # https://github.com/intridea/omniauth

  # provider(:openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'openid') if SETTINGS['providers'].include?('openid')
  # provider(:google, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google') if SETTINGS['providers'].include?('google')
  #
  # use(OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'),
  #     :name => 'yahoo',
  #     :identifier => 'yahoo.com') \
  #     if SETTINGS['providers'].include?('yahoo')
  #
  # use(OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'),
  #     :name => 'google',
  #     :identifier => 'https://www.google.com/accounts/o8/id') \
  #     if SETTINGS['providers'].include?('google')
end

consumers = {}
SETTINGS['auth_credentials'].each do |provider_name, opts|
  strategy_class = OmniAuth::Strategies.const_get("#{OmniAuth::Utils.camelize(provider_name)}")
  strategy = strategy_class.new(nil, opts['key'], opts['secret'])

  if strategy.is_a?(OmniAuth::Strategies::OAuth)
    consumers[provider_name] = strategy.consumer
  elsif strategy.is_a?(OmniAuth::Strategies::OAuth2)
    consumers[provider_name] = strategy.client
  end
end

OAUTH_CONSUMERS = consumers
