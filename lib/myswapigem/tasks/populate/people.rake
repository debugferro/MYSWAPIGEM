require 'rake'
require "myswapigem/tasks/populate/populator"

  namespace :populate do
    desc 'popdatabase'
    task people: :environment do
      include MYSWAPIGEM
      Populator.new.run
    end
  end
