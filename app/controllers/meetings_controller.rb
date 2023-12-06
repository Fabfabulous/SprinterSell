class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[ show edit update destroy ]

  def index
    @meetings = Meeting.all
  end

  def show
  end

  def new
    @meeting = Meeting.new
  end

  def create
    @user = current_user
    @meeting = Meeting.new(meeting_params)
    duration = meeting_params[:hour]
    @meeting.hour = @meeting.date + duration.to_i.minutes
    @meeting.user = @user
    company = @meeting.company
    previous_meeting_company = @user.meetings.where('date >= ? AND date < ?', DateTime.current.beginning_of_day, @meeting.date)
                                     .order(:date)
                                     .last
                                     &.company
    next_meeting_company = @user.meetings.where('date >= ? AND date < ?', @meeting.date, DateTime.current.end_of_day)
                                         .order(:date)
                                         .first
                                         &.company

    coordinates_first = [previous_meeting_company, company].map { |c| { latitude: c.latitude, longitude: c.longitude } }
    coordinates_last = [company, next_meeting_company].map { |c| { latitude: c.latitude, longitude: c.longitude } }
    # @company = Company.find(params[:id])
    # recuperer une company et lui associer un meeting
    Mapbox.access_token = ENV["MAPBOX_API_KEY"]
    duration_itinerary_first = Mapbox::Directions.directions(coordinates_first, "driving-traffic").dig(0, "routes", 0, "duration")&.fdiv(60)&.round if previous_meeting_company
    duration_itinerary_last = Mapbox::Directions.directions(coordinates_last, "driving-traffic").dig(0, "routes", 0, "duration")&.fdiv(60)&.round if next_meeting_company

    sql_query = "date > :start AND date < :end OR hour > :start AND hour < :end"
    if current_user.meetings.where(sql_query, start: @meeting.date, end: @meeting.hour).empty?
      if @meeting.save
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    elsif

    else
      redirect_to root_path, notice: "You already have a meeting at this time "
    end
  end

  def edit
  end

  def update
    if @meeting.user == current_user
      if @meeting.update(meeting_params)
        redirect_to root_path, notice: "Meeting successfully updated !"
        # redirect_to meetings_path, notice: "meeting successfully updated !"
      else
        redirect_to root_path, alert: @meeting.errors.full_messages.join(", ")
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
