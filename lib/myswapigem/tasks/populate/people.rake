require 'myswapigem/tasks/populate/populator'
require 'myswapigem/main'
require 'rake'

namespace :myswapigem do
  desc 'Populate or keep your database updated with SWAPI records.'
  task populate: :environment do
    MYSWAPIGEM::Populator.new.run
  end
end
