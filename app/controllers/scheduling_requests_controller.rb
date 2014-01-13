# TODO
#
# @author Brendan MacDonell
class SchedulingRequestsController < ApplicationController
  before_action :authenticate_user!

  def show
    @request = SchedulingRequest.new(
      date_in_week: Date.today + 6.weeks,
      day_start_time: Time.parse('8:30'),
      day_end_time: Time.parse('16:30'),
    )
    authorize @request
  end

  def create
    @request = SchedulingRequest.new(date_in_week: date_in_week_param,
                                     day_start_time: day_start_time_param,
                                     day_end_time: day_end_time_param)
    authorize @request

    if @request.valid?
      flash[:notice] = "Scheduling request submitted successfully.
                        Oral presentation tasks will be automatically assigned
                        to students.
                        Please check back in a few minutes to see the results."
      SchedulingService.delay.schedule_all(@request.date_in_week,
                                           @request.day_start_time,
                                           @request.day_end_time)
      redirect_to scheduling_request_path
    else
      render 'show'
    end
  end

  # For some reason, ActiveModel is missing the ability to convert dates
  #  and times from parameters to ruby objects. The following methods
  #  implement this missing functionality for scheduling requests.

  def date_in_week_param
    date_param(:scheduling_request, :date_in_week)
  end

  def day_start_time_param
    datetime_param(:scheduling_request, :day_start_time)
  end

  def day_end_time_param
    datetime_param(:scheduling_request, :day_end_time)
  end

  def datetime_fields(object, name, count)
    (1..count).map {|i| params[object]["#{name}(#{i}i)"].to_i }
  end

  def date_param(object, name)
    Date.new(*datetime_fields(object, name, 3))
  end

  def datetime_param(object, name)
    DateTime.new(*datetime_fields(object, name, 5))
  end

end
