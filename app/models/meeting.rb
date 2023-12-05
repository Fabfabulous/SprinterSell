class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :contact, optional: true
  validates :title, :date, :hour, presence: true
end
