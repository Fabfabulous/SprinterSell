class PagesController < ApplicationController
  def home
    @companies = Company.all
    @markers = @companies.geocoded.map do |company|
      {
        lat: company.latitude,
        lng: company.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { company: })
      }
    end
    @companies_prospect = Company.limit(5).where(status: 0)
    @companies_prospect_to_visit = Company.where(status: 2)
  end
end
