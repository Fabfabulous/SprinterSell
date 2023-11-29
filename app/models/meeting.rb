class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :contact
  has_one :company, through: :contact

end
