class PagesController < ApplicationController
  def home
    @companies = Company.all
    # The `geocoded` scope filters only company with coordinates
    @markers = @companies.geocoded.map do |company|
      {
        lat: company.latitude,
        lng: company.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { company: company })
      }
    end
  end
end
