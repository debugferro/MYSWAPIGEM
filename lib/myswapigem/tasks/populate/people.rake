require 'rake'
require "myswapigem/tasks/populate/populator"
require "myswapigem/main"

  namespace :populate do
    desc 'popdatabase'
    task people: :environment do
      MYSWAPIGEM::Populator.new.run
    end
  end
