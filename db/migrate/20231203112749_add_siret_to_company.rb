class AddSiretToCompany < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :siren, :string
  end
end
