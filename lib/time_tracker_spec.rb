require 'rspec'
require_relative 'lib/time_tracker'

RSpec.describe TimeTracker do
  let(:tracker) { TimeTracker.new }

  before do
    allow(HTTParty).to receive(:get).and_return(double(success?: true, 'logs' => log_data))
  end

  describe '#print_total_time_spent_by_content' do
    let(:log_data) do
      [
        { 'content_url' => 'https://example.com/tasks/1', 'time_spent' => 30 },
        { 'content_url' => 'https://example.com/tasks/1', 'time_spent' => 20 },
        { 'content_url' => 'https://example.com/challenges/2', 'time_spent' => 40 }
      ]
    end

    it 'prints the total time spent by content' do
      expect { tracker.print_total_time_spent_by_content }.to output(
        "Task 1: 50 minutes\nChallenge 2: 40 minutes\n"
      ).to_stdout
    end
  end

  describe '#print_median_time_spent_by_content' do
    let(:log_data) do
      [
        { 'content_url' => 'https://example.com/tasks/1', 'time_spent' => 30 },
        { 'content_url' => 'https://example.com/tasks/1', 'time_spent' => 20 },
        { 'content_url' => 'https://example.com/tasks/1', 'time_spent' => 40 },
        { 'content_url' => 'https://example.com/challenges/2', 'time_spent' => 40 },
        { 'content_url' => 'https://example.com/challenges/2', 'time_spent' => 50 }
      ]
    end

    it 'prints the median time spent by content' do
      expect { tracker.print_median_time_spent_by_content }.to output(
        "Task 1: 30 minutes\nChallenge 2: 50 minutes\n"
      ).to_stdout
    end
  end
end