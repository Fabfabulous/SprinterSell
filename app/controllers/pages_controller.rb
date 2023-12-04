class PagesController < ApplicationController
  def home
    @meetings = Meeting.where("date > ? AND date < ?", DateTime.now.at_beginning_of_day, DateTime.now.end_of_day)
    @companies = @meetings.map(&:company)
    @companies_suggestion = []
    @markers_prospect = []
    @markers = []
    @companies.each do |meeting_company|
      @markers.push(
        {
          lat: meeting_company.latitude,
          lng: meeting_company.longitude,
          info_window_html: render_to_string(partial: "info_window", locals: { company: meeting_company })
        }
      )
      Company.all.each do |company|
        if company.latitude
          test_distance = haversine_distance(meeting_company.latitude, meeting_company.longitude, company.latitude, company.longitude)
          if test_distance < 0.4 && company != meeting_company
            @companies_suggestion.push(company)
            @markers_prospect.push({
              lat: company.latitude,
              lng: company.longitude,
              info_window_html: render_to_string(partial: "info_window", locals: { company: })
            })
          end
        end
      end
    end
    @companies_prospect = Company.limit(5).where(status: 0)
    @companies_prospect_to_visit = Company.where(status: 2)
  end
  def map
    @companies_all = Company.all
    @markers = []
    if params[:filter].present?
      if params[:filter][:status] != ""
        @companies_all = @companies_all.where('status = ? ', params[:filter][:status])
      end
    end
    @companies_all.each do |company|
      if company.latitude?
        @markers.push(
          {
            lat: company.latitude,
            lng: company.longitude,
            info_window_html: render_to_string(partial: "info_window", locals: { company: })
          }
        )
      end
    end
  end

  private
  # Méthode pour convertir les degrés en radians
  def deg2rad(deg)
      return deg * (Math::PI / 180)
  end

  # Méthode pour calculer la distance entre deux points GPS en utilisant la formule Haversine
  def haversine_distance(lat1, lon1, lat2, lon2)
    # Conversion des degrés en radians
    lat1_rad = deg2rad(lat1)
    lon1_rad = deg2rad(lon1)
    lat2_rad = deg2rad(lat2)
    lon2_rad = deg2rad(lon2)

    # Calcul des différences de latitude et de longitude
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    # Calcul de la distance en utilisant la formule Haversine
    a = Math.sin(dlat / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    # Rayon de la Terre en kilomètres
    r = 6371.0

    # Distance en kilomètres
    distance = r * c

    return distance
  end
end
