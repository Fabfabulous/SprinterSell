# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Contact.destroy_all
Meeting.destroy_all
Company.destroy_all
User.destroy_all


CompaniesapiJob.perform_now

puts "!!!  START COMPANY/CONTACT CREATION  !!!"

25.times do
  companie = Company.where(status: 0).sample
  companie.status = "client"
  companie.save
end



Company.all.each do |company|
  puts "company status: #{company.status}"
  if company.status == "client"
    contact = Contact.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      function: Faker::Company.profession,
      email: Faker::Internet.unique.email,
      phone_number: Faker::PhoneNumber.phone_number_with_country_code,
      service: Faker::Company.department,
      company_id: company.id
    )
    contact.save!
  end
end
p "création user Test"
user = User.new(
  first_name: "Rémi",
  last_name: "Lavigne",
  email: "test@gmail.com",
  password: "password",
  phone_number: "+33638493020",
  function: "président",
  admin: true
)
user.save!
p "création user terminée"

date = Time.now - 1.days
compte = 0

p "création meetings"
loop do
  meeting_number = Meeting.count
  date_meeting = (date + ((compte * 86400) / 2)).change({ hour: (8..17).to_a.sample, min: 0, sec: 0 })
  meeting = Meeting.new(
    title: Faker::DcComics.title,
    date: date_meeting,
    hour: date_meeting.change({ hour: (date_meeting.strftime("%H").to_i + [0, 1].sample), min: [15, 30, 45].sample }),
    content: Faker::DcComics.title
  )
  meeting.user = User.first
  meeting.company = Company.all.sample
  meeting.contact = Contact.all.sample if rand(2).zero?
  sql_query = "date > :start AND date < :end OR hour > :start AND hour < :end"
  meeting.save! if Meeting.where(sql_query, start: meeting.date, end: meeting.hour).empty?

  p meeting
  unless meeting_number == Meeting.count
    compte += 1
    break if Meeting.count == 14
  end
end

taille = [100, 200, 400, 500]
p "create wagon"
company = Company.new({
  name: "Le Wagon",
  address: "20 rue des capucins",
  zip_code: "69001",
  city: "LYON 01",
  latitude: 45.769649067482305,
  longitude: 4.834794894874223,
  company_size: taille.sample,
  status: 0,
  code_naf: "85.59A",
  siren: "794949917"
  })
company.save

puts "!!!  FINISH COMPANY/CONTACT/MEETINGS CREATION  !!!"
