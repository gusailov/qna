redis = { url: 'redis://:p4878f8b0bdfe284496ca43d781f9a27c9fc0818dfca324c35ebebbc2b76bdaf8@ec2-3-94-172-123.compute-1.amazonaws.com:22889' }
Sidekiq.configure_client do |config|
  config.redis = redis
end
Sidekiq.configure_server do |config|
  config.redis = redis
end