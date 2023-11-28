class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :contact
end
