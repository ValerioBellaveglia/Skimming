module Skimming
  module ParasiteModel
    extend ActiveSupport::Concern

    included do
      Skimming.configuration.options[name.demodulize.underscore][:skim_through].each do |association_name|
        has_many :collection_filters, through: association_name.to_sym, class_name: 'Skimming::CollectionFilter'
      end
    end

    def skim(collection, through: nil, object_name: nil, **skimming_instances)
      Skimming::Skimmer.new(self, collection, object_name, skimming_instances).skim_through through
    end
  end
end
