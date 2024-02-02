require 'dotenv'
if ENV.fetch('ENV', 'development') != 'production'
  Dotenv.load(".env.#{ENV.fetch('ENV', 'development')}")
end
