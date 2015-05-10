require 'spec_helper'

describe 'League' do
  # all tests should be run on any class that 'acts_league_like'
  LeagueLike::ALL_LEAGUE_CLASSES.each do |league_class|
    let(:league){ league_class.new }
    describe 'validations' do
      it { expect(league).to validate_presence_of :name }
    end
  end
end