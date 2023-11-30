class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :contact, optional: true
end
