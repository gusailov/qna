namespace :daily do
  task digest: :environment do
    DailyDigestJob.perform_now
  end
end