require 'spec_helper'

describe 'Post' do
  let(:post_params){ {} }
  let(:post){ Post.new post_params }

  describe 'validations' do
    it { expect(post).to validate_presence_of :title }
    it { expect(post).to validate_presence_of :user_id }
    it { expect(post).not_to validate_presence_of :post_id }
  end
  describe 'league validations' do
    let(:league_name){ "Culpepper's Cannons" }
    let(:league_type){ "FootballLeague" }
    let(:post_params){ {league_type: league_type, league_attributes: {name: league_name}} }

    before{ post.valid? }

    context 'with valid league attributes' do
      it do
        expect(post.errors.messages[:league]).to be_nil
      end
    end

    context 'with INVALID league attributes' do
      let(:league_name){ nil }
      it do
        expect(post.errors.messages[:"league.name"]).to include("can't be blank")
      end
    end
  end

  describe 'updating league attributes' do
    let(:post){ create_a_league_post }
    let!(:original_league){ post.league }

    context "updating an existing league's attributes" do
      before do
        post.league_attributes = {name: 'New Football'}
        post.save
      end
      it 'should only change the name of the league' do
        expect(post.league.name).to eq('New Football')
        expect(post.league_type).to eq('FootballLeague')
        expect(post.league_id).to eq(original_league.id)
      end
    end
    context "setting a new league type" do
      before do
        post.update_attributes(league_attributes: {name: 'New Hockey'}, league_type: "HockeyLeague")
      end
      it 'should create a new league and destroy the old one' do
        expect(post.league.name).to eq('New Hockey')
        expect(post.league_type).to eq('HockeyLeague')
        expect(FootballLeague.find_by id: original_league.id).to be_nil
      end
    end
  end
end