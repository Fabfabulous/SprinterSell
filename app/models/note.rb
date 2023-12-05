class Note < ApplicationRecord
  belongs_to :company
  has_many_attached :photos
end
