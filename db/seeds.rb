# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

company = Company.new(
  name: "Le Wagon",
  address: "20 rue des capucins",
  zip_code: "69001",
  city: "Lyon",
  latitude: 45.7694,
  longitude: 4.8345,
  status: 1,
  company_size: 10,
  code_naf: "8559A"
)
company.save!

puts "!!!  START CONTACT CREATION  !!!"
5.times do
  contact = Contact.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    function: Faker::Company.profession,
    email: Faker::Internet.unique.email,
    phone_number: Faker::PhoneNumber.phone_number_with_country_code,
    service: Faker::Company.department,
    company_id: 1
  )
  contact.save!
end
puts "!!!  FINISH CONTACT CREATION  !!!"
