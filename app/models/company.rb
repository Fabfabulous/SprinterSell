class Company < ApplicationRecord
  has_many :contacts, dependent: :destroy
  enum status: [ :prospect, :client ]
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
