redis = { url: Rails.application.credentials[:redis][:url] }
Sidekiq.configure_client do |config|
  config.redis = redis
end
Sidekiq.configure_server do |config|
  config.redis = redis
end