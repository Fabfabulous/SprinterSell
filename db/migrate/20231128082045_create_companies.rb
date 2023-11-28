class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :city
      t.float :latitude
      t.float :longitude
      t.integer :status
      t.integer :company_size
      t.string :code_naf

      t.timestamps
    end
  end
end
