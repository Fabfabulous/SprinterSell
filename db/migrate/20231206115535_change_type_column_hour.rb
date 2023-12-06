class ChangeTypeColumnHour < ActiveRecord::Migration[7.1]
  def change
    remove_column :meetings, :hour, :time
    add_column :meetings, :hour, :datetime
  end
end
