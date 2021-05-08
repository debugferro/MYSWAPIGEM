module MYSWAPIGEM
  class Main
    attr_reader :total_records, :records_left, :done, :page
    include HTTParty
    base_uri URL

    def initialize(page = nil)
      @total_records = 0
      @records_left = 0
      @done = false
    end

    def index(page)
      @response = self.class.get("/#{resource_name}/?page=#{page}")
      @results = @response.parsed_response['results']
      return unless @results

      calculate_left
      @done = true if @records_left.zero?
      @results.map { |r| r.transform_keys(&:to_sym) }
    end

    def find(id)
      @response = self.class.get("/#{resource_name}/#{id}")
      @results = @response.parsed_response.transform_keys!(&:to_sym)
    end

    private

    def resource_name
      self.class.name.split('::').second.downcase
    end

    def calculate_left
      @total_records = @response.parsed_response['count'] || @total_records
      @records_left = @total_records if @records_left.zero? && !@done
      @records_left -= @results.size
    end
  end
end
