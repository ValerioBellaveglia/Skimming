module Skimming
  module Model
    extend ActiveSupport::Concern

    included do
      has_and_belongs_to_many :collection_filters, class_name: 'Skimming::CollectionFilter'
    end

    def skim(collection, object_name: nil, **skimming_instances)
      Skimming::Skimmer.new(self, collection, object_name, skimming_instances).skim
    end
  end
end
