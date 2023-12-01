class PagesController < ApplicationController
  def home
    @meetings = Meeting.where("date > ? AND date < ?", DateTime.now.at_beginning_of_day, DateTime.now.end_of_day)
    @companies = @meetings.map(&:company)
    @markers = @companies.map do |company|
      {
        lat: company.latitude,
        lng: company.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { company: })
      }
    end
    @companies_prospect = Company.limit(5).where(status: 0)
    @companies_prospect_to_visit = Company.where(status: 2)
  end
  def map
    @companies = Company.all
    @markers = @companies.map do |company|
      {
        lat: company.latitude,
        lng: company.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { company: })
      }
    end
  end
end
