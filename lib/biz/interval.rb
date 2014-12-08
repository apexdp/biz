module Biz
  class Interval

    include Equalizer.new(:start_time, :end_time, :time_zone)

    attr_reader :start_time,
                :end_time,
                :time_zone

    def initialize(start_time, end_time, time_zone)
      @start_time = start_time
      @end_time   = end_time
      @time_zone  = time_zone
    end

    def endpoints
      [start_time, end_time]
    end

    def to_time_segment(week)
      TimeSegment.new(
        *endpoints.map { |endpoint|
          Time.new(time_zone).during_week(endpoint.week(week), endpoint)
        }
      )
    end

  end
end
