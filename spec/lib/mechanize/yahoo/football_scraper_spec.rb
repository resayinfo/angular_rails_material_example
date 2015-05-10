require 'spec_helper'

describe Yahoo::FootballScraper, :vcr do
  describe '.scrape_league_attributes!' do
    let(:scrape_results){ Yahoo::FootballScraper.scrape_league_attributes!(url) }

    context 'a public url' do
      let(:url){ 'http://football.fantasysports.yahoo.com/f1/1524628/settings' }
      let(:expected_results) do
        {
          name: "FantasyLeagueFinder",
          teams: 10,
          teams_filled: nil,
          entry_fee: nil,
          draft_date: DateTime.strptime('5/10 11:45pm PDT', "%d/%m %I:%M%p %Z").iso8601,
          draft_type: "Live Standard Draft",
          fractional_points: true,
          negative_points: true,
          trade_deadline: DateTime.parse('14/11/2014', "%d/%m").iso8601,
          playoff_teams: 6,
          playoff_weeks: 3,
          playoff_start_date: DateTime.parse('25/11/2014', "%d/%m").iso8601,
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
          draft_order: nil,
          seconds_per_draft_pick: nil,
          max_defensive_backs: nil,
          max_defensive_linemen: nil,
          max_defensive_teams: nil,
          max_kickers: nil,
          max_linebackers: nil,
          max_quarterbacks: nil,
          max_running_backs: nil,
          max_tight_ends: nil,
          max_wide_receivers: nil,
          scraped_league_type: 'Yahoo Football',
          url: url
        }
      end
      it "gets all of the settings from the url" do
        expect(scrape_results).to eq(expected_results)
      end
    end

    context 'a private url' do
      let(:url){ 'http://football.fantasysports.yahoo.com/f1/1525345/settings' }

      it "raises the right error" do
        expect{ scrape_results }.to(
          raise_error(LeagueScraper::PrivateLeagueError, "cannot scrape settings of a private Yahoo Football league")
        )
      end
    end

    context 'an unsupported domain' do
      let(:url){ 'http://football.fantasysports.espn.com/f1/1525345/settings' }

      it "raises the right error" do
        expect{ scrape_results }.to(
          raise_error(LeagueScraper::UrlError, "Yahoo Football url must include 'football.fantasysports.yahoo.com'")
        )
      end
    end

    context 'a bad subdirectory' do
      let(:url){ 'http://football.fantasysports.yahoo.com/f1/1525345/NOsettingsHERE' }

      it "raises the right error" do
        expect{ scrape_results }.to(
          raise_error(LeagueScraper::SettingsNotFoundError, "no settings found at Yahoo Football url")
        )
      end
    end
  end
end