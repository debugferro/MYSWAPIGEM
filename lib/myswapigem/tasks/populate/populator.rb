require 'myswapigem/main'
require 'myswapigem/films'
require 'myswapigem/planets'
require 'myswapigem/species'
require 'myswapigem/vehicles'
require 'myswapigem/starships'

require 'myswapigem/page'
require 'myswapigem/tasks/populate/resource'
require 'myswapigem/tasks/populate/association'

module MYSWAPIGEM
  class Populator
    attr_reader :relations
    def initialize(list_of_resources = %w[People Film Planet Species Starship Vehicle])
      @list_of_resources = list_of_resources
      @total_records = 0
      @relations = {}
    end

    def run
      register_relations
      @associations = []
      @list_of_resources.each do |resource|
        create_find_update_resources(resource)
      end
      update_associations
    end

    private

    def create_find_update_resources(resource)
      @resource_class = "::#{resource.capitalize}".constantize
      @target_class = "MYSWAPIGEM::#{resource.capitalize.pluralize}".constantize
      @target_class = @target_class.new

      @page = Page.new
      until @target_class.done
        break if @target_class.done

        request_and_iterate_over_results
        @page.next_page
      end
    end

    def request_and_iterate_over_results
      @api_results = @target_class.index(@page.current)
      @api_results&.each do |result|
        association = Association.new(@resource_class, @relations)
        resource = Resource.new(@resource_class, result, @list_of_resources, association, self)
        created_resource = resource.create
        @associations << association
        association.resource = created_resource if created_resource.present?
      end
    end

    def update_associations
      @associations.each(&:create_associations)
    end

    def register_relations
      @list_of_resources.each do |resource|
        resource_class = "::#{resource.capitalize}".constantize
        relations = resource_class.relations
        relations.each do |name, reference|
          @relations[resource_class.to_s.to_sym] = {} if @relations[resource_class.to_s.to_sym].nil?
          @relations[resource_class.to_s.to_sym][name.to_s] = reference.options[:class_name]
        end
      end
    end
  end
end
