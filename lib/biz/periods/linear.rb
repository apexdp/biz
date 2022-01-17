# frozen_string_literal: true

module Biz
  module Periods
    class Linear < SimpleDelegator

      def initialize(periods, shifts, selector)
        @periods   = periods.to_enum
        @shifts    = shifts.to_enum
        @selector  = selector
        @sequences = [@periods, @shifts]

        super(linear_periods)
      end

      private

      attr_reader :periods,
                  :shifts,
                  :selector,
                  :sequences

      def linear_periods
        Enumerator.new do |yielder|
          loop do
            if periods.any?
              periods.next and next if periods.peek.date == shifts.peek.date
            end

            yielder << begin
              selected = sequences
                .select(&:any?)
                .public_send(selector) { |sequence| sequence.peek.date }

              break if selected.nil?

              selected.next
            end
          end

          loop do yielder << periods.next end if periods.any?
        end
      end

    end
  end
end
