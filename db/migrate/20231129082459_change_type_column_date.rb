class ChangeTypeColumnDate < ActiveRecord::Migration[7.1]
  def change
    change_column :meetings, :date, :datetime
  end
end
