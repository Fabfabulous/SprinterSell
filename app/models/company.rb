class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  has_many :meetings, dependent: :destroy
  has_many :notes, dependent: :destroy
  enum status: [ :prospect, :client, :to_visit ]
  geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?
end
