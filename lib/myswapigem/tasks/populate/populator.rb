require 'myswapigem/main'
require 'myswapigem/films'

module MYSWAPIGEM
  class Populator
    def initialize(list_of_resources = %w[People Films])
      @list_of_resources = list_of_resources
      @total_records = 0
    end

    def run
      @target_class = "MYSWAPIGEM::#{@list_of_resources[0].capitalize}".constantize
      @target_class = @target_class.new
      api_results = @target_class.index
      # api_results_attributes = api_results.first.keys
      puts @list_of_resources
      resource_class = "::#{@list_of_resources[0].capitalize}".constantize
      create_resource(resource_class, api_results)

      # @attributes = ::People.new.attribute_names
      # @new_record = ::People.new
      # filter_attributes
      # @attributes.each do |attribute|
      #   # @results.each do |result|
      #     @new_record[attribute] = @results[0][attribute.to_sym]

      # end

      # puts @total_records
      # puts @records_left
    end

    private

    def create_resource(resource, api_results)
      new_record = resource.new

      record_attributes = new_record.attribute_names

      if api_results.is_a?(Array)
        api_results_attributes = api_results.first.keys
        perm_attributes = filter_attributes(new_record, api_results_attributes)
        result = create_resource_when_array(api_results, perm_attributes, new_record)
        begin
        result.save
        rescue NoMethodError
          debugger
        end    
        puts "Not saved" if result.persisted? == false
        return result if result.persisted?
      end

      if api_results.is_a?(Hash)
        api_results_attributes = api_results.keys
        perm_attributes = filter_attributes(new_record, api_results_attributes)
        result = create_resource_when_hash(api_results, perm_attributes, new_record)
        begin
        result.save
        rescue NoMethodError
          debugger
        end
        puts "Not saved" if result.persisted? == false
        return result if result.persisted?
      end
      # perm_attributes = filter_attributes(new_record, api_results_attributes)
      # print perm_attributes
      # debugger
      # api_results.each do |result|
      #   perm_attributes.each do |attribute|
      #     resource = check_attribute(attribute, result[attribute.to_sym])
      #     if resource
      #       puts new_record[attribute]
      #       puts resource
      #       new_record[attribute] << resource
      #     else
      #       new_record[attribute] = result[attribute.to_sym]
      #     end
      #   end
      # end
      # if new_record.save
      #   puts new_record.persisted?
      #   new_record
      # end
    end

    def check_attribute(attribute, wanted_resource)
      if @list_of_resources.include?(attribute.to_s.capitalize)
        results = []
        record_resource = "::#{attribute.to_s.singularize.capitalize}".constantize
        gem_class = "MYSWAPIGEM::#{attribute.capitalize}".constantize
        wanted_resource.each do |resource|
          api_wanted_result = gem_class.new.find(resource.split('/').last)
          results << create_resource(record_resource, api_wanted_result)
        end
        results
      end
    end

    def filter_attributes(record, record_results_attributes)
      record_results_attributes.filter do |attribute|
        record.relations.key?(attribute) || attribute != 'id' && record.attribute_names.include?(attribute.to_s)
      end
    end

    def create_resource_when_array(api_results, perm_attributes, new_record)
      api_results.each do |result|
        perm_attributes.each do |attribute|
          resource = check_attribute(attribute, result[attribute.to_sym])
          if resource
            puts new_record[attribute]
            puts resource
            new_record.public_send(attribute) << resource
          else
            new_record[attribute] = result[attribute.to_sym]
          end
        end
      end
      new_record
    end

    def create_resource_when_hash(result, perm_attributes, new_record)
      perm_attributes.each do |attribute|
        resource = check_attribute(attribute, result[attribute.to_sym])
        if resource
          puts new_record[attribute]
          puts resource
          new_record[attribute] << resource
        else
          new_record[attribute] = result[attribute.to_sym]
        end
      end
      new_record
    end
  end
end
