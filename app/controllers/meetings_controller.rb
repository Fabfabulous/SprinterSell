class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[ show edit update destroy ]

  def index
    @meetings = Meeting.all
  end

  def show
    @meeting = Meeting.find(params[:id])
  end

  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.user = current_user
    if @meeting.save
      # redirect_to meetings_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @meeting.user == current_user
      if @meeting.update(meeting_params)
        # redirect_to meetings_path, notice: "meeting successfully updated !"
      else
        render :new, status: :unprocessable_entity
      end
    else
      # redirect_to meetings_path, alert: 'You are not authorized to update meetings.'
    end
  end

  def destroy
    @meeting.destroy
    # redirect_to meetings_path, status: :see_other
  end

  private

  def set_meeting
    @meeting = meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :date, :content, :user_id, :contact_id, :created_at, :updated_at)
  end
end
