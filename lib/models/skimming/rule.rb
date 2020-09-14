module Skimming
  class Rule < ActiveRecord::Base
    belongs_to :filter, class_name: 'Skimming::Filter', inverse_of: :rule, foreign_key: :filter_id

    validates_presence_of :statement
  end
end
