class AddCompanyToMeetings < ActiveRecord::Migration[7.1]
  def change
    add_reference :meetings, :company, null: false, foreign_key: true
  end
end
