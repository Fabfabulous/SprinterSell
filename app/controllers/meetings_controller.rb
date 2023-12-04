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
    duration = meeting_params[:hour]
    @meeting.hour = @meeting.date + duration.to_i.minutes
    @meeting.user = current_user
    # @company = Company.find(params[:id])
    # recuperer une company et lui associer un meeting
    if @meeting.save
      redirect_to root_path()
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @meeting.user == current_user
      if meeting_params[:hour].nil?
        @meeting.hour = set_meeting.hour
      end
      if @meeting.update(meeting_params)
        redirect_to root_path, notice: "Meeting successfully updated !"
        # redirect_to meetings_path, notice: "meeting successfully updated !"
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to root_path, notice: "You are not authorized to update this meeting."
      # redirect_to meetings_path, alert: 'You are not authorized to update meetings.'
    end
  end

  def destroy
    if @meeting.destroy
      redirect_to root_path, notice: "the meeting has been cancelled"
    # redirect_to meetings_path, status: :see_other
    end
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def meeting_params
    params.require(:meeting).permit(:title, :date, :content, :hour, :user_id, :company_id, :created_at, :updated_at)
  end
end
