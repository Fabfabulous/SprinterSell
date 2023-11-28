class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]
  def index
    @contacts = Contact.all
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = contact.new(contact_params)
    @contact.user = current_user
  end

  def edit
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :function, :email, :phone_number, :service, :comments)
  end
end
