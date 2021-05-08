require 'myswapigem/main'
require 'myswapigem/films'
require 'myswapigem/tasks/populate/populator'
require 'myswapigem/tasks/populate/resource'

module MYSWAPIGEM
  class Association
    attr_accessor :resource, :urls
    def initialize(resource_class, relations, urls = {})
      @resource_class = resource_class
      @resource = resource
      @relations = relations
      @urls = urls
    end

    def create_associations
      @urls.each do |type, urls|
        found_resources = []
        urls.each do |url|
          associated_class = @relations[@resource_class.to_s.to_sym][type.to_s].to_s.constantize
          found_resources << associated_class.where(url: url).last
        end
        found_resources.compact!
        begin
          is_array = @resource.public_send(type).is_a?(Array)
          @resource.public_send(type) << found_resources if is_array
          unless is_array
            # type_id = "#{type}_id".to_sym
            @resource.write_attribute(type, found_resources.first&.id) if found_resources.present?
          end
          message = "=> #{@resource_class}, id: #{@resource.id}, updated it's associated #{type} records."
          puts message if @resource.save
        rescue StandardError => e
          puts '=================================================='
          puts "=> Couldn't save #{@resource_class}. Error: #{e}\n"
          puts '=================================================='
        end
      end
    end
  end
end
