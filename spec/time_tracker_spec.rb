require 'time_tracker'
require 'webmock/rspec'

RSpec.describe TimeTracker do
  before do
    allow(HTTParty).to receive(:get).with(TimeTracker::TIME_TRACKING_ENDPOINT)
      .and_return(double(code: 200, body: { 'logs' => log_data }.to_json, headers: { 'Content-Type' => 'application/json' }))
  end
  
  let(:tracker) { TimeTracker.new }
  let(:log_data) do
    [
      { 'content_url' => 'https://www.workramp.com/tasks/1', 'time_spent' => 30 },
      { 'content_url' => 'https://www.workramp.com/tasks/1', 'time_spent' => 45 },
      { 'content_url' => 'https://www.workramp.com/challenges/2', 'time_spent' => 60 },
      { 'content_url' => 'https://www.workramp.com/challenges/2', 'time_spent' => 90 }
    ]
  end

  before do
    stub_request(:get, TimeTracker::TIME_TRACKING_ENDPOINT)
      .to_return(status: 200, body: { 'logs' => log_data }.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe '#print_total_time_spent_by_content' do
    it 'prints the total time spent by content' do
      expect { tracker.print_total_time_spent_by_content }.to output(
        "Task 1: 75 minutes\nChallenge 2: 150 minutes\n"
      ).to_stdout
    end
  end

  describe '#print_median_time_spent_by_content' do
    it 'prints the median time spent by content' do
      expect { tracker.print_median_time_spent_by_content }.to output(
        "Task 1: 45 minutes\nChallenge 2: 90 minutes\n"
      ).to_stdout
    end
  end

  describe '#fetch_data' do
  it 'fetches data from the endpoint' do
    tracker.send(:fetch_data)
    expect(tracker.instance_variable_get(:@log_data)).to eq(log_data)
  end

  it 'raises an error if the request fails' do
    allow(HTTParty).to receive(:get).with(TimeTracker::TIME_TRACKING_ENDPOINT)
      .and_return(double(code: 500, body: 'Internal Server Error'))

    expect { tracker.send(:fetch_data) }.to raise_error(RuntimeError, 'Failed to fetch data: 500 Internal Server Error')
  end
end
end