module Skimming
  class Skimmer
    attr_reader :subject, :collection, :collection_name, :skimming_instances

    def initialize(subject, collection, object_name, skimming_instances)
      @subject = subject
      @collection = collection
      @collection_name = object_name || calculate_collection_name
      @skimming_instances = skimming_instances
    end

    def skim
      set_instance_variables

      filters_rules = subject.collection_filters.for_object(collection_name).map(&:rule)

      return collection if filters_rules.empty?

      skimming_result = collection.select do |collection_object|
        instance_variable_set("@#{collection_name}", collection_object)

        filters_rules.all? { |rule| eval rule }
      end

      skimming_result
    end

    def skim_through(skimming_associations)
      set_instance_variables

      skimming_associations = Skimming.configuration.options[subject.class.name.underscore][:skim_through] if skimming_associations.blank?
      skimming_associations = [skimming_associations] unless skimming_associations.respond_to? :each
      skimming_result = []

      skimming_associations.each do |association_name|
        subject.send(association_name.to_sym).each do |skimming_object|
          skimming_result += skimming_object.skim(collection, subject.class.name.downcase.to_sym => subject)
        end
      end

      skimming_result.uniq
    end

    private

    def calculate_collection_name
      raise 'Invalid collection: contains objects with different classes' unless collection.map(&:class).uniq.count == 1

      collection.first.class.name.downcase
    end

    def set_instance_variables
      instance_variable_set("@#{subject.class.name.downcase}", subject)

      skimming_instances.each do |instance_name, instance_object|
        instance_variable_set("@#{instance_name}", instance_object)
      end
    end
  end
end
