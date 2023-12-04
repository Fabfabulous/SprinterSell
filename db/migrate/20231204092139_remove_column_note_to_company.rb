class RemoveColumnNoteToCompany < ActiveRecord::Migration[7.1]
  def change
    remove_column :companies, :note, :text
  end
end
