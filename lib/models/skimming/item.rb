module Skimming
  class Item < ActiveRecord::Base
    has_many :filters, class_name: 'Skimming::Filter', inverse_of: :item, foreign_key: :item_id

    validates :name, presence: true, uniqueness: true

    attr_readonly :name

    before_validation :classify_name

    def classify_name
      self.name = self.name.classify
    end
  end
end
