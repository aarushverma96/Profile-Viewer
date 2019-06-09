require 'redis'

## Added rescue condition if Redis connection is failed
begin
  $redis = Redis.new(:host => 'localhost', :port => 6379) 
  $cache_redis = Redis.new(:host => 'localhost', :port => 6379, :db => 2) 
rescue Exception => e
  puts e
end