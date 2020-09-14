module Skimming
  class Filter < ActiveRecord::Base
    belongs_to :skimmable, polymorphic: true
    belongs_to :item, class_name: 'Skimming::Item', inverse_of: :filters, foreign_key: :item_id
    has_many :rules

    validates_presence_of :rules

    scope :for_item, -> (item_name) { joins(:item).where(items: { name: item_name }) }
  end
end
