require 'rails/generators'

class SkimmingMigrationGenerator < Rails::Generators::Base

  def create_migration_file
    create_file "db/migrate/#{Time.zone.now.strftime("%Y%m%d%H%M%S")}_skimming_migration_1_0_0.rb", migration_data
  end

  private

  def migration_data
<<MIGRATION
class SkimmingMigration100 < ActiveRecord::Migration[5.2]
  def change
    unless table_exists? :items
      create_table :items do |t|
        t.string :name

        t.timestamps
      end
    end

    unless table_exists? :filters
      create_table :filters do |t|
        t.bigint :item_id
        t.bigint :skimmable_id
        t.string :skimmable_type

        t.timestamps
      end

      create_table :rules do |t|
        t.bigint :filter_id
        t.string :statement

        t.timestamps
      end
    end
  end
end
MIGRATION
  end
end
