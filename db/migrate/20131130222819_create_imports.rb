class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.datetime :datetime
      t.integer :valid_trials
      t.integer :valid_sites
    end
  end
end
