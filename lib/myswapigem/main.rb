module MYSWAPIGEM
  class Main
    attr_reader :total_records, :records_left
    include HTTParty
    base_uri URL

    def initialize(page = nil)
      @total_records = 0
      @records_left = 0
      @page = Page.new(page)
    end

    def index(page = nil)
      @page = Page.new(page) if page
      @response = self.class.get("/#{resource_name}/?page=#{@page.current}")
      @results = @response.parsed_response['results']
      calculate_left
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
      @total_records = @response.parsed_response['count']
      @records_left = @total_records - @results.size
    end
  end
end
