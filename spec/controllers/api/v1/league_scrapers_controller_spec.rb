require 'spec_helper'

describe Api::V1::LeagueScrapersController, :vcr do

  before :each do
    # avoid rendering html of single page app (RSpec only)
    request.env["HTTP_ACCEPT"] = "application/json"
  end

  let(:user) { User.where(admin: false).first }
  let(:posts) { user.posts }
  before { stub_login user }

  context "#show" do
    before{ get :show, {url: url} }

    describe 'with a url for Yahoo Football' do
      let(:url){ 'http://football.fantasysports.yahoo.com/f1/1524628/settings' }
      let(:league_attributes) do
        {
          name: "FantasyLeagueFinder",
          teams: 10,
          draft_date: DateTime.strptime('5/10 11:45pm PDT', "%d/%m %I:%M%p %Z").iso8601,
          draft_type: "Live Standard Draft",
          fractional_points: true,
          negative_points: true,
          trade_deadline: DateTime.parse('14/11/2014').iso8601,
          playoff_teams: 6,
          playoff_weeks: 3,
          playoff_start_date: DateTime.parse('25/11/2014').iso8601,
          waiver_rules: "Waiver Time: 2 days, Waiver Type: Continual rolling list, Weekly Waivers: None",
          starting_quarterbacks: 1,
          starting_wide_receivers: 1,
          starting_tight_ends: 1,
          starting_running_backs: 1,
          starting_kickers: 1,
          offensive_flex_positions: 4,
          starting_linebackers: 2,
          starting_defensive_backs: 4,
          starting_defensive_linemen: 8,
          starting_defensive_teams: 2,
          defensive_flex_positions: 2,
          bench_positions: 1,
          points_per_passing_yard: 0.04,
          points_per_passing_td: 4.0,
          points_per_interception: -1.0,
          points_per_rushing_yard: 0.1,
          points_per_rushing_td: 6.0,
          points_per_reception: 1.0,
          points_per_reception_yard: 0.1,
          points_per_reception_td: 6.0,
          points_per_return_td: 6.0,
          points_per_2_point_conversion: 2.0,
          points_per_fumbles_lost: -2.0,
          points_per_offensive_fumble_return_td: 6.0,
          field_goal_point_range: "3.0 to 5.0",
          field_goal_miss_point_range: "0.0 for any distance",
          points_per_point_after: 1.0,
          points_per_point_after_miss: 0.0,
          points_per_defensive_sack: 2.0,
          points_per_defensive_interception: 3.0,
          points_per_fumble_recovery: 2.0,
          points_per_defensive_td: 5.0,
          points_per_safety: 1.0,
          points_per_block_kick: 1.0,
          points_per_kickoff_and_punt_return_td: 6.0,
          points_allowed_range: "-4.0 to 10.0",
          injured_reserve_positions: 1,
          points_per_dst_sack: 1.0,
          points_per_dst_interception: 2.0,
          points_per_dst_fumble_recovery: 1.0,
          points_per_dst_td: 3.0,
          points_per_dst_safety: 2.0,
          points_per_dst_block_kick: 2.0,
          points_per_solo_tackle: 1.0,
          points_per_pass_defended: 0.5,
          points_per_tackle_assist: 0.5,
          points_per_fumble_forced: 2.0,
          points_per_dst_tackle_for_loss: 0.0,
          points_per_tackle_for_loss: 2.0,
          points_per_turnover_return_yard: 0.2,
          scraped_league_type: 'Yahoo Football',
          url: url
        }
      end

      it 'returns a serialized league scraped from the url' do
        expect(json_response).to                                                          have_key(:league_scraper)
        expect(json_response[:league_scraper][:name]).to                                  eq(league_attributes[:name])
        expect(json_response[:league_scraper][:teams]).to                                 eq(league_attributes[:teams])
        expect(json_response[:league_scraper][:draft_date]).to                            eq(league_attributes[:draft_date])
        expect(json_response[:league_scraper][:draft_type]).to                            eq(league_attributes[:draft_type])
        expect(json_response[:league_scraper][:fractional_points]).to                     eq(league_attributes[:fractional_points])
        expect(json_response[:league_scraper][:negative_points]).to                       eq(league_attributes[:negative_points])
        expect(json_response[:league_scraper][:trade_deadline]).to                        eq(league_attributes[:trade_deadline])
        expect(json_response[:league_scraper][:playoff_teams]).to                         eq(league_attributes[:playoff_teams])
        expect(json_response[:league_scraper][:playoff_weeks]).to                         eq(league_attributes[:playoff_weeks])
        expect(json_response[:league_scraper][:playoff_start_date]).to                    eq(league_attributes[:playoff_start_date])
        expect(json_response[:league_scraper][:waiver_rules]).to                          eq(league_attributes[:waiver_rules])
        expect(json_response[:league_scraper][:starting_quarterbacks]).to                 eq(league_attributes[:starting_quarterbacks])
        expect(json_response[:league_scraper][:starting_wide_receivers]).to               eq(league_attributes[:starting_wide_receivers])
        expect(json_response[:league_scraper][:starting_tight_ends]).to                   eq(league_attributes[:starting_tight_ends])
        expect(json_response[:league_scraper][:starting_running_backs]).to                eq(league_attributes[:starting_running_backs])
        expect(json_response[:league_scraper][:starting_kickers]).to                      eq(league_attributes[:starting_kickers])
        expect(json_response[:league_scraper][:offensive_flex_positions]).to              eq(league_attributes[:offensive_flex_positions])
        expect(json_response[:league_scraper][:starting_linebackers]).to                  eq(league_attributes[:starting_linebackers])
        expect(json_response[:league_scraper][:starting_defensive_backs]).to              eq(league_attributes[:starting_defensive_backs])
        expect(json_response[:league_scraper][:starting_defensive_linemen]).to            eq(league_attributes[:starting_defensive_linemen])
        expect(json_response[:league_scraper][:starting_defensive_teams]).to              eq(league_attributes[:starting_defensive_teams])
        expect(json_response[:league_scraper][:defensive_flex_positions]).to              eq(league_attributes[:defensive_flex_positions])
        expect(json_response[:league_scraper][:bench_positions]).to                       eq(league_attributes[:bench_positions])
        expect(json_response[:league_scraper][:points_per_passing_yard]).to               eq(league_attributes[:points_per_passing_yard])
        expect(json_response[:league_scraper][:points_per_passing_td]).to                 eq(league_attributes[:points_per_passing_td])
        expect(json_response[:league_scraper][:points_per_interception]).to               eq(league_attributes[:points_per_interception])
        expect(json_response[:league_scraper][:points_per_rushing_yard]).to               eq(league_attributes[:points_per_rushing_yard])
        expect(json_response[:league_scraper][:points_per_rushing_td]).to                 eq(league_attributes[:points_per_rushing_td])
        expect(json_response[:league_scraper][:points_per_reception]).to                  eq(league_attributes[:points_per_reception])
        expect(json_response[:league_scraper][:points_per_reception_yard]).to             eq(league_attributes[:points_per_reception_yard])
        expect(json_response[:league_scraper][:points_per_reception_td]).to               eq(league_attributes[:points_per_reception_td])
        expect(json_response[:league_scraper][:points_per_return_td]).to                  eq(league_attributes[:points_per_return_td])
        expect(json_response[:league_scraper][:points_per_2_point_conversion]).to         eq(league_attributes[:points_per_2_point_conversion])
        expect(json_response[:league_scraper][:points_per_fumbles_lost]).to               eq(league_attributes[:points_per_fumbles_lost])
        expect(json_response[:league_scraper][:points_per_offensive_fumble_return_td]).to eq(league_attributes[:points_per_offensive_fumble_return_td])
        expect(json_response[:league_scraper][:field_goal_point_range]).to                eq(league_attributes[:field_goal_point_range])
        expect(json_response[:league_scraper][:field_goal_miss_point_range]).to           eq(league_attributes[:field_goal_miss_point_range])
        expect(json_response[:league_scraper][:points_per_point_after]).to                eq(league_attributes[:points_per_point_after])
        expect(json_response[:league_scraper][:points_per_point_after_miss]).to           eq(league_attributes[:points_per_point_after_miss])
        expect(json_response[:league_scraper][:points_per_defensive_sack]).to             eq(league_attributes[:points_per_defensive_sack])
        expect(json_response[:league_scraper][:points_per_defensive_interception]).to     eq(league_attributes[:points_per_defensive_interception])
        expect(json_response[:league_scraper][:points_per_fumble_recovery]).to            eq(league_attributes[:points_per_fumble_recovery])
        expect(json_response[:league_scraper][:points_per_defensive_td]).to               eq(league_attributes[:points_per_defensive_td])
        expect(json_response[:league_scraper][:points_per_safety]).to                     eq(league_attributes[:points_per_safety])
        expect(json_response[:league_scraper][:points_per_block_kick]).to                 eq(league_attributes[:points_per_block_kick])
        expect(json_response[:league_scraper][:points_per_kickoff_and_punt_return_td]).to eq(league_attributes[:points_per_kickoff_and_punt_return_td])
        expect(json_response[:league_scraper][:points_allowed_range]).to                  eq(league_attributes[:points_allowed_range])
        expect(json_response[:league_scraper][:injured_reserve_positions]).to             eq(league_attributes[:injured_reserve_positions])
        expect(json_response[:league_scraper][:points_per_dst_sack]).to                   eq(league_attributes[:points_per_dst_sack])
        expect(json_response[:league_scraper][:points_per_dst_interception]).to           eq(league_attributes[:points_per_dst_interception])
        expect(json_response[:league_scraper][:points_per_dst_fumble_recovery]).to        eq(league_attributes[:points_per_dst_fumble_recovery])
        expect(json_response[:league_scraper][:points_per_dst_td]).to                     eq(league_attributes[:points_per_dst_td])
        expect(json_response[:league_scraper][:points_per_dst_safety]).to                 eq(league_attributes[:points_per_dst_safety])
        expect(json_response[:league_scraper][:points_per_dst_block_kick]).to             eq(league_attributes[:points_per_dst_block_kick])
        expect(json_response[:league_scraper][:points_per_solo_tackle]).to                eq(league_attributes[:points_per_solo_tackle])
        expect(json_response[:league_scraper][:points_per_pass_defended]).to              eq(league_attributes[:points_per_pass_defended])
        expect(json_response[:league_scraper][:points_per_tackle_assist]).to              eq(league_attributes[:points_per_tackle_assist])
        expect(json_response[:league_scraper][:points_per_fumble_forced]).to              eq(league_attributes[:points_per_fumble_forced])
        expect(json_response[:league_scraper][:points_per_dst_tackle_for_loss]).to        eq(league_attributes[:points_per_dst_tackle_for_loss])
        expect(json_response[:league_scraper][:points_per_tackle_for_loss]).to            eq(league_attributes[:points_per_tackle_for_loss])
        expect(json_response[:league_scraper][:points_per_turnover_return_yard]).to       eq(league_attributes[:points_per_turnover_return_yard])
        expect(json_response[:league_scraper][:scraped_league_type]).to                   eq(league_attributes[:scraped_league_type])
        expect(json_response[:league_scraper][:url]).to                                   eq(league_attributes[:url])
      end
    end

    describe 'with a url for Yahoo Hockey' do
      let(:url){ 'http://hockey.fantasysports.yahoo.com/hockey/87444/settings' }
      let(:league_attributes) do
        {
          name: "FantasyLeagueFinder",
          teams: 12,
          draft_date: DateTime.strptime('16/11 11:45pm PST', "%d/%m %I:%M%p %Z").iso8601,
          draft_type: "Live Standard Draft",
          trade_deadline: DateTime.parse('5/3/2015').iso8601,
          playoff_teams: 6,
          playoff_weeks: 3,
          playoff_start_date: DateTime.parse('9/3/2015').iso8601,
          waiver_rules: "Waiver Time: 2 days, Waiver Type: Continual rolling list, Waiver Mode: Standard",
          starting_centers: 2,
          starting_right_wings: 2,
          starting_left_wings: 2,
          starting_defensemen: 4,
          starting_goaltenders: 2,
          starting_flex_wings: 1,
          starting_flex_forwards: 2,
          injured_reserve_positions: 3,
          max_inactives: 1,
          utility_positions: 1,
          bench_positions: 2,
          score_goals: true,
          score_assists: true,
          score_points: true,
          score_plus_minus: true,
          score_penalty_minutes: true,
          score_powerplay_goals: true,
          score_powerplay_assists: true,
          score_powerplay_points: false,
          score_shorthanded_goals: true,
          score_shorthanded_points: false,
          score_shorthanded_assists: true,
          score_game_winning_goals: true,
          score_shots_on_goal: true,
          score_shooting_percentage: true,
          score_faceoffs_won: true,
          score_faceoffs_lost: false,
          score_hits: true,
          score_blocks: true,
          score_games_started: true,
          score_wins: true,
          score_losses: true,
          score_goals_against: true,
          score_goals_against_average: true,
          score_shots_against: true,
          score_saves: true,
          score_save_percentage: true,
          score_shutouts: true,
          scraped_league_type: 'Yahoo Hockey',
          url: url
        }
      end

      it 'returns a serialized league scraped from the url' do
        expect(json_response).to                                                have_key(:league_scraper)
        expect(json_response[:league_scraper][:name]).to                        eq(league_attributes[:name])
        expect(json_response[:league_scraper][:teams]).to                       eq(league_attributes[:teams])
        expect(json_response[:league_scraper][:draft_date]).to                  eq(league_attributes[:draft_date])
        expect(json_response[:league_scraper][:draft_type]).to                  eq(league_attributes[:draft_type])
        expect(json_response[:league_scraper][:trade_deadline]).to              eq(league_attributes[:trade_deadline])
        expect(json_response[:league_scraper][:playoff_teams]).to               eq(league_attributes[:playoff_teams])
        expect(json_response[:league_scraper][:playoff_weeks]).to               eq(league_attributes[:playoff_weeks])
        expect(json_response[:league_scraper][:playoff_start_date]).to          eq(league_attributes[:playoff_start_date])
        expect(json_response[:league_scraper][:waiver_rules]).to                eq(league_attributes[:waiver_rules])
        expect(json_response[:league_scraper][:starting_centers]).to            eq(league_attributes[:starting_centers])
        expect(json_response[:league_scraper][:starting_right_wings]).to        eq(league_attributes[:starting_right_wings])
        expect(json_response[:league_scraper][:starting_left_wings]).to         eq(league_attributes[:starting_left_wings])
        expect(json_response[:league_scraper][:starting_defensemen]).to         eq(league_attributes[:starting_defensemen])
        expect(json_response[:league_scraper][:starting_goaltenders]).to        eq(league_attributes[:starting_goaltenders])
        expect(json_response[:league_scraper][:starting_flex_wings]).to         eq(league_attributes[:starting_flex_wings])
        expect(json_response[:league_scraper][:starting_flex_forwards]).to      eq(league_attributes[:starting_flex_forwards])
        expect(json_response[:league_scraper][:injured_reserve_positions]).to   eq(league_attributes[:injured_reserve_positions])
        expect(json_response[:league_scraper][:max_inactives]).to               eq(league_attributes[:max_inactives])
        expect(json_response[:league_scraper][:utility_positions]).to           eq(league_attributes[:utility_positions])
        expect(json_response[:league_scraper][:bench_positions]).to             eq(league_attributes[:bench_positions])
        expect(json_response[:league_scraper][:score_goals]).to                 eq(league_attributes[:score_goals])
        expect(json_response[:league_scraper][:score_assists]).to               eq(league_attributes[:score_assists])
        expect(json_response[:league_scraper][:score_points]).to                eq(league_attributes[:score_points])
        expect(json_response[:league_scraper][:score_plus_minus]).to            eq(league_attributes[:score_plus_minus])
        expect(json_response[:league_scraper][:score_penalty_minutes]).to       eq(league_attributes[:score_penalty_minutes])
        expect(json_response[:league_scraper][:score_powerplay_goals]).to       eq(league_attributes[:score_powerplay_goals])
        expect(json_response[:league_scraper][:score_powerplay_assists]).to     eq(league_attributes[:score_powerplay_assists])
        expect(json_response[:league_scraper][:score_powerplay_points]).to      eq(league_attributes[:score_powerplay_points])
        expect(json_response[:league_scraper][:score_shorthanded_goals]).to     eq(league_attributes[:score_shorthanded_goals])
        expect(json_response[:league_scraper][:score_shorthanded_points]).to    eq(league_attributes[:score_shorthanded_points])
        expect(json_response[:league_scraper][:score_shorthanded_assists]).to   eq(league_attributes[:score_shorthanded_assists])
        expect(json_response[:league_scraper][:score_game_winning_goals]).to    eq(league_attributes[:score_game_winning_goals])
        expect(json_response[:league_scraper][:score_shots_on_goal]).to         eq(league_attributes[:score_shots_on_goal])
        expect(json_response[:league_scraper][:score_shooting_percentage]).to   eq(league_attributes[:score_shooting_percentage])
        expect(json_response[:league_scraper][:score_faceoffs_won]).to          eq(league_attributes[:score_faceoffs_won])
        expect(json_response[:league_scraper][:score_faceoffs_lost]).to         eq(league_attributes[:score_faceoffs_lost])
        expect(json_response[:league_scraper][:score_hits]).to                  eq(league_attributes[:score_hits])
        expect(json_response[:league_scraper][:score_blocks]).to                eq(league_attributes[:score_blocks])
        expect(json_response[:league_scraper][:score_games_started]).to         eq(league_attributes[:score_games_started])
        expect(json_response[:league_scraper][:score_wins]).to                  eq(league_attributes[:score_wins])
        expect(json_response[:league_scraper][:score_losses]).to                eq(league_attributes[:score_losses])
        expect(json_response[:league_scraper][:score_goals_against]).to         eq(league_attributes[:score_goals_against])
        expect(json_response[:league_scraper][:score_goals_against_average]).to eq(league_attributes[:score_goals_against_average])
        expect(json_response[:league_scraper][:score_shots_against]).to         eq(league_attributes[:score_shots_against])
        expect(json_response[:league_scraper][:score_saves]).to                 eq(league_attributes[:score_saves])
        expect(json_response[:league_scraper][:score_save_percentage]).to       eq(league_attributes[:score_save_percentage])
        expect(json_response[:league_scraper][:score_shutouts]).to              eq(league_attributes[:score_shutouts])
        expect(json_response[:league_scraper][:scraped_league_type]).to         eq(league_attributes[:scraped_league_type])
        expect(json_response[:league_scraper][:url]).to                         eq(league_attributes[:url])
      end
    end

    describe 'with a url for Yahoo Baseball' do
      let(:url){ 'http://baseball.fantasysports.yahoo.com/b1/154128/settings' }
      let(:league_attributes) do
        {}
      end

      it 'returns a serialized league scraped from the url' do
      end
    end

    describe 'with bad urls' do
      context 'a private url' do
        let(:url){ 'http://football.fantasysports.yahoo.com/f1/1525345/settings' }

        it "returns the right error" do
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors]).to have_key('LeagueScraper::PrivateLeagueError')
          expect(json_response[:errors]['LeagueScraper::PrivateLeagueError'][0]).to eq('cannot scrape settings of a private Yahoo Football league')
        end
      end

      context 'a bad url' do
        let(:url){ 'http://hockey.fantasysports.yahoo.com/hockey/87444/THESEareNOTtheSETTINGSyoureLOOKINGfor' }

        it "returns the right error" do
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors]).to have_key('LeagueScraper::SettingsNotFoundError')
          expect(json_response[:errors]['LeagueScraper::SettingsNotFoundError'][0]).to eq('no settings found at Yahoo Hockey url')
        end
      end

      context 'unsupported league' do
        let(:url){ 'http://games.espn.go.com/ffl/leaguesetup/settings?leagueId=1908150' }
        it 'returns the right error' do
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors]).to have_key('LeagueScraper::UrlError')
          expect(json_response[:errors]['LeagueScraper::UrlError'][0]).to eq('url must be for one of the following: Yahoo Football, Yahoo Hockey, Yahoo Baseball, Espn Hockey, Espn Baseball')
        end
      end

      context 'unsupported scoring type' do
        let(:url){ 'http://games.espn.go.com/fhl/leaguesetup/settings?leagueId=81162' }
        it 'returns the right error' do
          expect(json_response).to have_key(:errors)
          expect(json_response[:errors]).to have_key('LeagueScraper::ScoringTypeError')
          expect(json_response[:errors]['LeagueScraper::ScoringTypeError'][0]).to eq("scoring type must be 'Head to Head Each Category' for Espn Hockey")
        end
      end
    end
  end
end