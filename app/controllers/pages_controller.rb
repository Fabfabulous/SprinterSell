class PagesController < ApplicationController
  def home
    @meetings = Meeting.where("date > ? AND date < ?", DateTime.now.at_beginning_of_day, DateTime.now.end_of_day).order(date: :asc)
    @companies = @meetings.map(&:company)
    @next_meeting = Meeting.where('date >= ? AND date < ?', DateTime.current, DateTime.current.end_of_day).order(date: :asc).first
    unless @next_meeting.nil?
      @gps_next_meeting = [{ lng: @next_meeting.company.longitude, lat: @next_meeting.company.latitude }]
      @waze_url = "https://www.waze.com/ul?ll=#{@gps_next_meeting.first[:lat]}%2C#{@gps_next_meeting.first[:lng]}&navigate=yes"
    end
    @companies_suggestion = []
    @travel_times = {}
    @markers = []
    @companies.each do |meeting_company|
      marker_color = define_color(meeting_company)
      @compteur = 0
      @markers.push(
        {
          lat: meeting_company.latitude,
          lng: meeting_company.longitude,
          info_window_html: render_to_string(partial: "info_window", locals: { company: meeting_company }),
          color: marker_color
        }
      )
      Company.where.not(id: @companies.pluck(:id)).each do |company|
        if company.latitude
          test_distance = haversine_distance(meeting_company.latitude, meeting_company.longitude, company.latitude, company.longitude)
          if test_distance < 0.4 && company != meeting_company
            if @compteur < 5
              @travel_times[company.name.to_sym] = {distance: (test_distance * 1000).to_i, meeting: meeting_company.name}
              @companies_suggestion.push(company)
            end
            @compteur += 1
          end
        end
      end
    end
  end

  def map
    @markers = []
    if params[:status].present?
      @companies_all = Company.where('status = ? ', params[:status]).limit(20)
    elsif params[:query].present?
      @companies_all = Company.where('name ILIKE ?', "%#{params[:query]}%").limit(50)
    else
      @companies_all = Company.where(status: 1).limit(20)
      @companies_all += Company.where(status: 0).limit(80)
    end


    @companies_all.each do |company|
      next unless company.latitude?

      marker_color = define_color(company)
      @markers.push(
        {
          lat: company.latitude,
          lng: company.longitude,
          info_window_html: render_to_string(partial: "info_window", locals: { company: }, formats: [:html]),
          color: marker_color
        }
      )
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.json do
        render json: {
          companies_html: render_to_string(partial: "pages/company-list", locals: { companies: @companies_all, type: "card" }, formats: [:html]),
          markers: @markers
        }
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
    a = (Math.sin(dlat / 2)**2) + (Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon / 2)**2))
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    # Rayon de la Terre en kilomètres
    r = 6371.0

    # Distance en kilomètres
    distance = r * c

    return distance
  end

  def define_color(company)
    case company.status
      when 'prospect'
        '#FF8787 '
      when 'client'
        '#63E6bE'
      when 'to_visit'
        '#74C0FC'
      else
        '#FFD43B'
    end
  end
end
