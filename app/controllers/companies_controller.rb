class CompaniesController < ApplicationController
  def search_company
    @companies = Company.where('name ILIKE ?', "%#{params[:query]}%").limit(5)
    render json: { companies_partial: render_to_string(partial: "pages/note_company_list", locals: { companies: @companies }, formats: :html)}
  end
end
