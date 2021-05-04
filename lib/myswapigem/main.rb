module MYSWAPIGEM
  class Main
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
      calculate_left
      @response = @response.parsed_response['results']
      @response.map { |r| r.transform_keys(&:to_sym) }
    end

    def find(id)
      @response = self.class.get("/#{resource_name}/#{id}")
      JSON.parse(@response)
    end

    def where
    end

    private

    def resource_name
      self.class.name.split('::').second.downcase
    end

    def calculate_left
      @total = @response.parsed_response['count']
      @record_left = @total - @response.size
    end
  end
end
