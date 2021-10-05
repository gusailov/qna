redis = { url: 'redis://redistogo:4c04a08a24ee46b9e01f14195b3b5c7a@tarpon.redistogo.com:9003/4' }
Sidekiq.configure_client do |config|
  config.redis = redis
end
Sidekiq.configure_server do |config|
  config.redis = redis
end