require "myswapigem/version"
require "httparty"

module MYSWAPIGEM
  class Error < StandardError; end
  URL = 'https://swapi.dev/api/'
end

require "myswapigem/tasks/populate/populator"
require "myswapigem/railtie" if defined?(Rails)
require "myswapigem/page"
require "myswapigem/main"
require "myswapigem/people"
