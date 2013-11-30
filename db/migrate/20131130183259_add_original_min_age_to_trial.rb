class AddOriginalMinAgeToTrial < ActiveRecord::Migration
  def change
    add_column :trials, :originalminage, :text
    add_column :trials, :originalmaxage, :text
  end
end
