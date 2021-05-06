require "myswapigem/main"
require "myswapigem/people"

module MYSWAPIGEM
  class Populator

    def initialize(list_of_resources = ['People', 'Films', 'Planets', 'Species', 'Starships', 'Vehicles'])
      @list_of_resources = list_of_resources
      @total_records = 0
    end

    def run
      # target_class = "MYSWAPIGEM::#{@list_of_resources[0].capitalize}".constantize
      # target_class = target_class.new
      # target_class.index
      # puts target_class.records_left
      teste = People.new
      teste.index
      puts teste.get_records_left
      # puts @total_records
      # puts @records_left
    end

    private

    def resource_name
      @resource_name
    end
  end
end
