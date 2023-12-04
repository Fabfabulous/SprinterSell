class AddColumnNoteToCompany < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :note, :text
  end
end
