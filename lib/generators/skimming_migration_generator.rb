require 'rails/generators'

class SkimmingMigrationGenerator < Rails::Generators::Base

  def create_migration_file
    create_file "db/migrate/#{Time.zone.now.strftime("%Y%m%d%H%M%S")}_skimming_migration.rb", migration_data
  end

  private

  def migration_data
<<MIGRATION
  class SkimmingMigration < ActiveRecord::Migration[5.2]
    # 0.0.1 Release
    def change
      unless table_exists? :collection_filters
        create_table :collection_filters do |t|
          t.string :object_name
          t.string :rule

          t.timestamps
        end

        #{generate_join_tables_creation_data}
      end
    end
  end
MIGRATION
  end

  def generate_join_tables_creation_data
    join_tables_creation_data = ""
    associations = Skimming.configuration.associations.keys

    associations.each do |association|
      join_tables_creation_data += "create_join_table :collection_filters, :#{association}#{"\n        " unless association == associations.last}"
    end

    join_tables_creation_data
  end
end
