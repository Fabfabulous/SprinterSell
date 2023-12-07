class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :contact, optional: true
  validates :title, presence: true
  validates :date, presence: true
  validates :hour, presence: true
end
