require 'merge_two_strings'

RSpec.describe MergeTwoStrings do
  let(:mts) { MergeTwoStrings.new }

  it 'merges two strings of equal length' do
    expect(mts.merge_alternately('abc', 'def')).to eql('adbecf')
  end

  it 'merges two strings when the first is longer' do
    expect(mts.merge_alternately('abcd', 'ef')).to eql('aebfcd')
  end

  it 'merges two strings when the second is longer' do
    expect(mts.merge_alternately('ab', 'cdef')).to eql('acbdef')
  end
end
