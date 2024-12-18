require 'api_rate_limiter'

RSpec.describe ApiRateLimiter do
  let(:arl) { ApiRateLimiter.new }
  let(:user_id1) { 1 }
  let(:user_id2) { 2 }

  it 'allows less than the default number of calls per minute' do
    expect(arl.api_call(user_id1)).to eql(true)
  end

  it 'allows the maximum number of calls per minute' do
    10.times do
      expect(arl.api_call(user_id1)).to eql(true)
    end
  end

  it 'raises an exception when more than the maximum number of calls per minute are made' do
    10.times do
      expect(arl.api_call(user_id1)).to eql(true)
    end

    expect { arl.api_call(user_id1) }.to raise_error(StandardError, 'RATE_LIMIT_EXCEEDED')
  end

  it 'allows 2 users make more than the max # of calls combined' do
    10.times do
      expect(arl.api_call(user_id1)).to eql(true)
    end

    expect(arl.api_call(user_id2)).to eql(true)
  end

  it 'allows a user to make more than the max # of calls when rate limit respected' do
    10.times do
      expect(arl.api_call(user_id1)).to eql(true)
    end

    sleep(61)

    expect(arl.api_call(user_id1)).to eql(true)
  end
end
