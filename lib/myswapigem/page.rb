module MYSWAPIGEM
  class Page
    attr_reader :current, :next_pg, :previous

    def initialize(page = nil, next_pg = nil, previous = nil)
      @current = page || 1
      @next = next_pg || @current + 1
      @previous = previous || @current - 1
    end

    def next_page
      @current += 1
      @previous += 1
      @next += 1
    end

    def previous_page
      @next -= 1
      @current -= 1
      @previous -= 1
    end
  end
end
