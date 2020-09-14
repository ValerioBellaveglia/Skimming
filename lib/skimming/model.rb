module Skimming
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :filters, class_name: 'Skimming::Filter', as: :skimmable
    end

    module ClassMethods
      def skim_through(association)
        has_many :filters, through: association, class_name: 'Skimming::Filter', source: :filters
      end
    end

    def skim(collection, item_name: nil, **skimming_instances)
      Skimming::Skimmer.new(self, collection, item_name, skimming_instances).skim
    end
  end
end
