require 'fourchette'
require_relative 'callbacks'
require_relative 'heroku'
require_relative 'pull_request'
require_relative 'web'
require_relative 'fork'
run Sinatra::Application
