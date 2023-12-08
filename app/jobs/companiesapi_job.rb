class CompaniesapiJob < ApplicationJob
  queue_as :default
  require 'open-uri'

  def perform
    taille = [100, 200, 400, 500]
    naf = "85.59A"
    zipcode = 69_001
    regex = /^6900\d$/
    9.times do
      page = 1
      url = "https://recherche-entreprises.api.gouv.fr/search?q=#{zipcode}%20Lyon&activite_principale=#{naf}&categorie_entreprise=PME%2CETI&departement=69&page=#{page}&per_page=25"
      response = JSON.parse(URI.open(url).read, symbolize_names: true)
      response[:total_pages].times do
        url = "https://recherche-entreprises.api.gouv.fr/search?q=#{zipcode}%20Lyon&activite_principale=#{naf}&categorie_entreprise=PME%2CETI&departement=69&page=#{page}&per_page=25"
        response = JSON.parse(URI.open(url).read, symbolize_names: true)
        response[:results].each do |result|
          unless  result[:siege][:code_postal].nil?
            if Company.find_by(siren: result[:siren]).nil? && result[:siege][:code_postal].to_s.match(regex) && (result[:nom_complet].length < 20)
              company = Company.new({
                name: result[:nom_complet],
                address: result[:siege][:adresse],
                zip_code: result[:siege][:code_postal],
                city: result[:siege][:libelle_commune],
                latitude: result[:siege][:latitude],
                longitude: result[:siege][:longitude],
                company_size: taille.sample,
                status: 0,
                code_naf: naf,
                siren: result[:siren]
                })
                p company
                company.save
            end
          end
        end
        sleep 0.2
        page += 1
      end
      sleep 0.6
      zipcode += 1
      p zipcode
    end
  end
end
