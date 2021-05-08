require 'myswapigem/main'
require 'myswapigem/films'
require 'myswapigem/tasks/populate/association'

module MYSWAPIGEM
  attr_accessor :associations, :resource
  class Resource
    def initialize(resource, api_results, list_of_resources, association, populator)
      @resource = resource
      @api_results = api_results
      @association = association
      @list_of_resources = list_of_resources
      @populator = populator
    end

    # Criação de recurso
    def create
      @new_record = @resource.new
      @api_results = [@api_results] if @api_results.is_a?(Hash)
      @api_results_attributes = @api_results.first.keys
      @perm_attributes = filter_attributes
      @result = write_attributes
      @result.save
      if @result.persisted?
        puts "=> Created #{@resource}, id: #{@result.id}."
        @result
      else
        update
      end
    end

    # Verificando se update ou não
    def update
      @found_resource = search_for_similar_record
      if update_allowed?
        return save_update_resource if update_existant

        puts "=> #{@resource}, id: #{@found_resource.id}, is persisted and up to date."
        return @found_resource
      end
      puts "=> Couldn't create #{@resource}. Errors: #{@result.errors.full_messages.join(', ')}"
      @found_resource
    end

    # Update em um recurso
    def update_existant
      relations = @found_resource.relations.keys
      updated = false
      @perm_attributes.each do |attribute|
        next if relations.include?(attribute.to_s)

        next unless @found_resource.public_send(attribute) != @result.public_send(attribute)

        @found_resource.write_attribute(attribute, @result.public_send(attribute))
        updated = true
      end
      updated
    end

    private

    # Salvando recurso que sofreu um update
    def save_update_resource
      @found_resource.save
      return unless @found_resource.persisted?

      puts "=> Updated #{@resource}, id: #{@found_resource.id}"
      @found_resource
    end

    # Verificando se o update dos dados é permitida
    def update_allowed?
      env = ENV['allow_update']
      env_condition = YAML.safe_load(ENV['allow_update']) if env
      env_condition && @found_resource.present?
    end

    # ASSIT CREATE METHODS:

    # Filtrando quais parametros existem no nosso banco de dados
    def filter_attributes
      @api_results_attributes.filter do |attribute|
        attribute = ENV["#{@resource.to_s.downcase}_#{attribute}_association_name"] || attribute # Verificando se o atributo recebe outro nome
        @new_record.relations.key?(attribute) || attribute != 'id' && @new_record.attribute_names.include?(attribute.to_s)
      end
    end

    def search_for_similar_record
      @attributes = @result.raw_attributes
      search_opts = define_search_opts
      attributes = search_opts ? select_attributes_by_options(search_opts) : select_all_attributes_but_the_id
      @resource.where(attributes).last
    end

    # Checando variáveis de pesquisa
    def define_search_opts
      if ENV["search_#{@resource.to_s.pluralize.downcase}_by"]
        YAML.safe_load(ENV["search_#{@resource.to_s.pluralize.downcase}_by"])
      else
        ['url']
      end
    end

    def select_attributes_by_options(opts)
      @attributes.slice(*opts)
    end

    def select_all_attributes_but_the_id
      @attributes.delete('_id')
    end

    # CREATE METHODS:

    # Ligamento entre o dado enviado pela API e o registro no banco de dados.
    def write_attributes
      @api_results.each do |result|
        @perm_attributes.each do |attribute|
          resource = check_association_attribute(attribute, result[attribute.to_sym])
          @new_record[attribute] = result[attribute.to_sym] unless resource
        end
      end
      @new_record
    end

    # Checagem de associações relacionadas ao registro. Salvando para criação posterior.
    def check_association_attribute(attribute, wanted_resource)
      targeted_class_name = @populator.relations[@resource.to_s.to_sym][attribute.to_s]
      if @list_of_resources.include?(targeted_class_name)
        wanted_resource = [wanted_resource] unless wanted_resource.is_a?(Array)
        wanted_resource.each do |resource|
          symbolized_attr = attribute.to_s.to_sym
          @association.urls[symbolized_attr] = [] if @association.urls[symbolized_attr].nil?
          @association.urls[symbolized_attr] << resource
        end
        return true
      end
      false
    end
  end
end
