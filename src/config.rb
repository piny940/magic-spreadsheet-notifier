require 'dotenv'
if ENV.fetch('RACK_ENV', 'development') != 'production'
  Dotenv.load(".env.#{ENV.fetch('RACK_ENV', 'development')}")
end
