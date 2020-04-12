module Skimming
  class CollectionFilter < ActiveRecord::Base
    Skimming.configuration.associations.each do |association_name, association_options|
      has_and_belongs_to_many association_name.to_sym, class_name: association_options[:class_name], inverse_of: :collection_filters, foreign_key: "#{association_name}_id".to_sym
    end

    validates_presence_of :object_name, :rule

    scope :for_object, -> (object_name) { where(object_name: object_name) }
  end
end
