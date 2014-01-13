# A very greedy, stupid implementation of a presentation scheduler. In fact,
#  packing is a totally foreign concept to it. When all else fails, it just
#  asks for new venues. Fortunately, this project isn't about scheduling
#  presentations (that was it's own four-person project a few years ago!),
#  so this approach is acceptable as it is easier to implement that an
#  interface to manually schedule groups.
#
# @author Brendan MacDonell (Please don't hold it against me ...)

module OralPresentationScheduling
  BEGINNING_OF_WEEK = :sunday
  DAYS_PER_WEEK = 7
  MINUTES_PER_BLOCK = 15

  # Domain object that manages the period of time in which presentations are
  #  scheduled, such as which week they occur in, when they start and end each
  #  day, and what time zone they are to be scheduled in.
  class ScheduleRange
    def initialize(date_in_week, day_start_time, day_end_time)
      @date_in_week = date_in_week
      @day_start_minute = time_to_minute(day_start_time)
      @day_end_minute = time_to_minute(day_end_time)
      @all_timeslots = nil
    end

    # Convert a Time object to a number of minutes since midnight.
    def time_to_minute(time)
      time.seconds_since_midnight / 60
    end

    def blocks_per_day
      (@day_end_minute - @day_start_minute) / MINUTES_PER_BLOCK
    end

    def minute_to_block(minute)
      (minute - @day_start_minute) / MINUTES_PER_BLOCK
    end

    def block_to_minute(block)
      block * MINUTES_PER_BLOCK + @day_start_minute
    end

    # Returns true if the time interval specified overlaps with the time
    #  period in which presentations are scheduled each day, or false otherwise.
    def overlaps?(start_minute, end_minute)
      raise "start must be less than end" if start_minute >= end_minute

      ((start_minute >= @day_start_minute && start_minute < @day_end_minute) ||
       (end_minute <= @day_end_minute && end_minute > @day_start_minute))
    end

    # Returns an array of Timeslots covering all schedulable days and times.
    def all_timeslots
      unless @all_timeslots.present?
        @all_timeslots = (1..5).map do |day_id|
          Timeslot.new(day_id, @day_start_minute, @day_end_minute)
        end
      end

      @all_timeslots
    end

    # Returns a DateTime corresponding to a specified day in the week (where
    #  Sunday is day 0, Monday is day 1, etc.) and block. The DateTime will be
    #  in the time zone configured for the ScheduleRange.
    def datetime_for(day_id, block)
      @date_in_week
        .beginning_of_week(BEGINNING_OF_WEEK)
        .to_datetime
        .change(hour: 0, min: 0, sec: 0)
        .advance(days: day_id, minutes: block_to_minute(block))
    end
  end

  # Represents a period of time that a project group is available on
  #  a specific day.
  class Timeslot
    attr_reader :day_id, :start_minute, :end_minute

    def initialize(schedule_range, day_id, start_minute, end_minute)
      @schedule_range = schedule_range
      @day_id = day_id
      @start_minute = start_minute
      @end_minute = end_minute
    end

    def valid?
      in_schedule_range = @schedule_range.overlaps?(start_minute, end_minute)
      non_empty = end_minute - start_minute > 0
      in_schedule_range && non_empty
    end

    def start_block
      @schedule_range.minute_to_block(@start_minute)
    end

    def end_block
      @schedule_range.minute_to_block(@end_minute)
    end

    def blocks
      end_block - start_block
    end

    # TODO: This really should be in the service itself.
    def self.timeslots_for(schedule_range, form)
      form.decode_available_times.map do |time|
        self.new(schedule_range, time['dayId'],
                 time['startTime'], time['endTime'])
      end.select(&:valid?)
    end
  end

  # Represents the availability information associated with an instance of
  #  OralPresentationForm. This includes a collection of timeslots, a
  #  reference to the project itself, and the number of blocks of time needed
  #  to schedule the presentation.
  class Availability
    attr_reader :blocks_needed

    def initialize(schedule_range, form)
      @form = form
      @schedule_range = schedule_range
      @blocks_needed = form.project.group_members.count
      @timeslots = nil
    end

    def project
      @form.project
    end

    def constrainedness
      timeslots
        .map { |ts| (ts.blocks - @blocks_needed) ** 2 }
        .sum
    end

    # Returns all timeslots for a specific filled form. Invalid timeslots (ie.
    #  those that are too short, or fall outside of the scheduled presentation
    #  time range) will be discarded. If no timeslots are valid, then the
    #  group is assumed to always be available, regardless of what they
    #  entered in their form.
    def timeslots
      unless @timeslots.present?
        timeslots = Timeslot
          .timeslots_for(@schedule_range, @form)
          .select { |ts| ts.blocks >= @blocks_needed }
        timeslots = @schedule_range.all_timeslots if timeslots.empty?
        @timeslots = timeslots.sort_by { |ts| [ts.day_id, ts.start_minute] }
      end

      @timeslots
    end
  end

  # Represents an interval of time that has been scheduled for a project.
  #  Reservation instances are used by the scheduler as the service object
  #  is solely responsible for manipulating the database and creating
  #  OralPresentation tasks.
  class Reservation
    attr_reader :project, :venue, :day_id, :start_block, :end_block

    def initialize(schedule_range, project, venue, day_id,
                   start_block, end_block)
      @schedule_range = schedule_range
      @project = project
      @venue = venue
      @day_id = day_id
      @start_block = start_block
      @end_block = end_block
    end

    def start_datetime
      @schedule_range.datetime_for(@day_id, @start_block)
    end

    def end_datetime
      @schedule_range.datetime_for(@day_id, @end_block)
    end
  end

  # Control object that handles scheduling a series of oral presentations
  #  based on submitted OralPresentationForms. Its main entry point is
  #  Scheduler#schedule_all.
  class Scheduler
    extend Forwardable

    def_delegator :@schedule_range, :blocks_per_day

    def initialize(availabilities, schedule_range)
      @availabilities = availabilities
      @schedule_range = schedule_range

      # @venues holds a Hash, where each mapping in the hash represents
      #  the schedule for a specific venue. Each such schedule is an array
      #  of seven elements, each corresponding to a day of the week. Each
      #  day-of-the-week slot holds an array of boolean values, one per block
      #  in the day. A true value for the boolean means that the given time
      #  is already allocated, while false means that it is available.
      @venues = {}
    end

    def schedule_all
      @availabilities
        .sort_by(&:constrainedness)
        .map { |availability| schedule(availability) }
    end

    def schedule(availability)
      reservation = find_start_time_and_venue(availability)
      mark_reserved(reservation)
      reservation
    end

    private

    # Create a new venue when the algorithm can't find space for a group.
    def create_venue
      @venues[@venues.length] = Array
        .new(DAYS_PER_WEEK, nil)
        .map { Array.new(blocks_per_day, false) }
      nil
    end

    # Returns a Reservation if an available time interval and venue is found, or
    #  nil if the given timeslot can't be scheduled.
    def find_venue_for_timeslot(availability, timeslot)
      blocks_needed = availability.blocks_needed
      day_id = timeslot.day_id

      start_block = [0, timeslot.start_block].max
      finish_block = [blocks_per_day, timeslot.end_block].min

      @venues.each do |venue, venue_blocks_used|
        blocks_used_for_day = venue_blocks_used[day_id]

        for window_start_block in start_block...(finish_block - blocks_needed)
          window_blocks_used = blocks_used_for_day[window_start_block, blocks_needed]
          is_available = window_blocks_used.none?

          if is_available
            window_end_block = window_start_block + blocks_needed
            return Reservation.new(@schedule_range, availability.project, venue,
                                   day_id, window_start_block, window_end_block)
          end
        end
      end

      nil
    end

    # Returns a Reservation indicating when a group can be scheduled
    #  based on their submitted oral presentation form. If no timeslot is
    #  available in their current set of venues, another one will be created.
    def find_start_time_and_venue(availability, have_created_venue=false)
      availability.timeslots.each do |timeslot|
        reservation = find_venue_for_timeslot(availability, timeslot)
        return reservation if reservation.present?
      end

      # If we reach here, we failed to find an appropriate timeslot.
      if have_created_venue
        # This should be impossible, but just in case it somehow happens ...
        raise "Unable to allocate form for #{availability.project.name}"
      else
        create_venue
        find_start_time_and_venue(availability, have_created_venue=true)
      end
    end

    # Marks the time interval and venue corresponding to a Reservation as used.
    def mark_reserved(reservation)
      blocks = @venues[reservation.venue][reservation.day_id]

      for block_index in reservation.start_block...reservation.end_block
        blocks[block_index] = true
      end

      nil
    end
  end

end


class SchedulingService
  include OralPresentationScheduling

  def initialize(date_in_week, day_start_time, day_end_time)
    @schedule_range = ScheduleRange.new(date_in_week, day_start_time,
                                        day_end_time)
  end

  def schedule_all
    scheduler = Scheduler.new(availabilities, @schedule_range)
    reservations = scheduler.schedule_all
    clear_existing_presentations
    reservations.map { |r| create_oral_presentation_task(r) }
  end

  private

  def availabilities
    OralPresentationForm
      .all
      .includes(project: [:group_members])
      .map { |form| Availability.new(@schedule_range, form) }
  end

  def clear_existing_presentations
    OralPresentation.destroy_all
  end

  def create_oral_presentation_task(reservation)
    start = reservation.start_datetime
    finish = reservation.end_datetime

    deadline = Deadline.unique
    deadline.timestamp = start

    deadline.transaction do
      deadline.save!
      OralPresentation.create(
        project: reservation.project,
        deadline: deadline,
        venue: "##{reservation.venue + 1}",
        date: start.to_date,
        start: start.to_time,
        finish: finish.to_time,
      )
    end
  end

end
