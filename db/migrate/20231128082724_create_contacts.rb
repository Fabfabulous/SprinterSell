class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :function
      t.string :email
      t.string :phone_number
      t.string :service
      t.string :comments
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
