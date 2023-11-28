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
    if @contact.save
      redirect_to contacts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contact.user == current_user
      if @contact.update(contact_params)
        redirect_to contacts_path, notice: "contact successfully updated !"
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to contacts_path, alert: 'You are not authorized to update contacts.'
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path, status: :see_other
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :function, :email, :phone_number, :service, :comments)
  end
end
