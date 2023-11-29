class Contact < ApplicationRecord
  belongs_to :company
  has_many :meetings, dependent: :destroy
end
