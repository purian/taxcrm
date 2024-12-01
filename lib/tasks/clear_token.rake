namespace :token do
  desc "Clear authentication token from cache"
  task clear: :environment do
    if Rails.cache.delete(:token)
      puts "Successfully cleared authentication token from cache"
    else
      puts "No authentication token found in cache"
    end
  end
end
