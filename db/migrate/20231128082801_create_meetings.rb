class CreateMeetings < ActiveRecord::Migration[7.1]
  def change
    create_table :meetings do |t|
      t.string :title
      t.date :date
      t.time :hour
      t.references :user, null: false, foreign_key: true
      t.references :contact, null: true, foreign_key: true

      t.timestamps
    end
  end
end
