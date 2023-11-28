class AddContentToMeetings < ActiveRecord::Migration[7.1]
  def change
    add_column :meetings, :content, :string
  end
end
