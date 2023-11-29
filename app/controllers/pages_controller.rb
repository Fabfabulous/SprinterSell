class PagesController < ApplicationController
  def home
    @companies_prospect = Company.where(status: 0)
    @companies_prospect_to_visit = Company.where(status: 2)
  end
end
