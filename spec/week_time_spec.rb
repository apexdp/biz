RSpec.describe Biz::WeekTime do
  subject(:week_time) {
    described_class.new(week_minute(wday: 0, hour: 9, min: 30))
  }

  context "when initializing" do
    context "with an integer" do
      it "is successful" do
        expect(described_class.new(1).week_minute).to eq 1
      end
    end

    context "with an valid integer-like value" do
      it "is successful" do
        expect(described_class.new('1').week_minute).to eq 1
      end
    end

    context "with an invalid integer-like value" do
      it "fails hard" do
        expect { described_class.new('1one') }.to raise_error ArgumentError
      end
    end

    context "with a non-integer value" do
      it "fails hard" do
        expect { described_class.new([]) }.to raise_error TypeError
      end
    end
  end

  describe ".from_time" do
    let(:time) { Time.new(2006, 1, 9, 9, 30) }

    it "creates the proper week time" do
      expect(described_class.from_time(time)).to(
        eq week_minute(wday: 1, hour: 9, min: 30)
      )
    end
  end

  describe "#wday" do
    context "when the time is contained within a day" do
      subject(:week_time) {
        described_class.new(week_minute(wday: 0, hour: 12))
      }

      it "returns the weekday integer for that day" do
        expect(week_time.wday).to eq 0
      end
    end

    context "when the time is on a day boundary" do
      subject(:week_time) {
        described_class.new(week_minute(wday: 1, hour: 0))
      }

      it "returns the weekday integer for the midnight day" do
        expect(week_time.wday).to eq 1
      end
    end

    context "when the time is the last minute of the week" do
      subject(:week_time) {
        described_class.new(week_minute(wday: 7, hour: 0))
      }

      it "returns the weekday integer for Sunday" do
        expect(week_time.wday).to eq 0
      end
    end
  end

  describe "#wday_symbol" do
    context "when the time is contained within a day" do
      subject(:week_time) {
        described_class.new(week_minute(wday: 0, hour: 12))
      }

      it "returns the weekday symbol for that day" do
        expect(week_time.wday_symbol).to eq :sun
      end
    end

    context "when the time is on a day boundary" do
      subject(:week_time) {
        described_class.new(week_minute(wday: 1, hour: 0))
      }

      it "returns the weekday symbol for the midnight day" do
        expect(week_time.wday_symbol).to eq :mon
      end
    end
  end

  describe "#week" do
    let(:base_week) { Biz::Week.new(0) }

    context "when the time is the first minute of the week" do
      subject(:week_time) { described_class.new(week_minute(wday: 0, hour: 0)) }

      it "returns the base week" do
        expect(week_time.week(base_week)).to eq base_week
      end
    end

    context "when the time is in the middle of the week" do
      subject(:week_time) {
        described_class.new(week_minute(wday: 4, hour: 18))
      }

      it "returns the base week" do
        expect(week_time.week(base_week)).to eq base_week
      end
    end

    context "when the time is the last minute of the week" do
      subject(:week_time) { described_class.new(week_minute(wday: 7, hour: 0)) }

      it "returns the succeeding week" do
        expect(week_time.week(base_week)).to eq base_week.succ
      end
    end
  end

  describe "#day_minute" do
    it "returns the corresponding day minute" do
      expect(week_time.day_minute).to eq day_minute(hour: 9, min: 30)
    end
  end

  describe "#hour" do
    it "returns the corresponding hour" do
      expect(week_time.hour).to eq 9
    end
  end

  describe "#minute" do
    it "returns the corresponding minute" do
      expect(week_time.minute).to eq 30
    end
  end

  describe "#timestamp" do
    it "returns the corresponding timestamp" do
      expect(week_time.timestamp).to eq '09:30'
    end
  end

  describe "#strftime" do
    it "returns a properly formatted string" do
      expect(week_time.strftime('%A %H:%M %p')).to eq 'Sunday 09:30 AM'
    end
  end

  describe "#to_int" do
    it "returns the minutes since week start" do
      expect(week_time.to_int).to eq week_minute(wday: 0, hour: 9, min: 30)
    end
  end

  describe "#to_i" do
    it "returns the minutes since week start" do
      expect(week_time.to_i).to eq week_minute(wday: 0, hour: 9, min: 30)
    end
  end

  context "when performing comparison" do
    context "and the compared object does not respond to #to_i" do
      it "raises an argument error" do
        expect { week_time < Object.new }.to raise_error ArgumentError
      end
    end

    context "and the compared object responds to #to_i" do
      it "compares as expected" do
        expect(week_time > 100).to eq true
      end
    end

    context "and the comparing object is an integer" do
      it "compares as expected" do
        expect(100 < week_time).to eq true
      end
    end
  end
end
