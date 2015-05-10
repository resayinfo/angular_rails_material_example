require 'spec_helper'

describe 'PostsQueryFilter' do
  let(:ability){ Ability.new User.new }
  let(:params){ Hash.new }
  let(:query_filter){ PostsQueryFilter.new(params, ability) }

  describe '#run_query' do
    let!(:user){ create_bill_murray }
    let(:ability){ Ability.new user }

    shared_examples_for 'only returns the expected records' do
      it { expect(query_filter.run_query.to_a).to eq(expected_records.to_a) }
    end

    context 'without params' do
      let(:expected_records) do
        Post.order(created_at: :desc )
      end
      it_behaves_like 'only returns the expected records'
    end

    context 'with sort_order param' do
      let!(:first_post_league)  { FactoryGirl.create :football_league, draft_date: 1.day.from_now }
      let!(:third_post_league)  { FactoryGirl.create :football_league, draft_date: 1.day.ago }
      let!(:second_post_league) { FactoryGirl.create :football_league, draft_date: Time.now }
      let!(:other_league)       { FactoryGirl.create :hockey_league }
      let!(:first_post)         { FactoryGirl.create :post, title: '__FIRST_LEAGUE__', league: first_post_league }
      let!(:second_post)        { FactoryGirl.create :post, title: '__SECOND_LEAGUE__', league: second_post_league }
      let!(:third_post)         { FactoryGirl.create :post, title: '__THIRD_LEAGUE__', league: third_post_league }
      let!(:other_post)         { FactoryGirl.create :post, title: '__OTHER_LEAGUE__', league: other_league }

      let(:expected_records){ [first_post, second_post, third_post] }
      let(:params) do
        {
          q: '_LEAGUE_',
          sort_order: 'football_leagues.draft_date',
        }
      end

      it_behaves_like 'only returns the expected records'

      it "doesn't n+1 itself" do
        query_count = ActiveRecord::Base.count_queries do
          posts = query_filter.run_query.to_a
          posts.each{|p| p.league.name}
        end

        expect(query_count).to eq(2)
      end

      context 'AND sort_direction param' do
        let(:expected_records){ [third_post, second_post, first_post] }
        let(:params) do
          super().merge(sort_direction: 'aSc')
        end

        it_behaves_like 'only returns the expected records'
      end
    end

    context 'with all the football league params', :search do
      let!(:wrong_league)       { FactoryGirl.create(:football_league) }
      let!(:deleted_post_league){ FactoryGirl.create(:football_league, default_factory_attributes(:football_league)) }
      let!(:expected_league)    { FactoryGirl.create(:football_league, default_factory_attributes(:football_league)) }
      let!(:expected_post)      { FactoryGirl.create(:post, league: expected_league) }
      let!(:deleted_post)       { FactoryGirl.create :post, title: (expected_post.title + '__DELETED'), deleted_at: Time.now, league: deleted_post_league }
      let!(:wrong_league_post)  { FactoryGirl.create :post, title: (expected_post.title + '__WRONG_LEAGUE'), league: wrong_league }
      let!(:no_league_post)     { FactoryGirl.create :post, title: (expected_post.title + '__NO_LEAGUE'), league: nil }

      let(:expected_records){ [expected_post] }
      let(:mixed_up_title){ mix_up_string expected_post.title }
      let(:params) do
        {
          q: mixed_up_title,
          league_type: 'FootballLeague',
          leaguejoin_teams: default_factory_attributes(:football_league)[:teams],
          leaguejoin_draft_date_gt: default_factory_attributes(:football_league)[:draft_date].beginning_of_day,
          leaguejoin_draft_date_lt: default_factory_attributes(:football_league)[:draft_date].end_of_day,
          leaguejoin_draft_order: default_factory_attributes(:football_league)[:draft_order],
          leaguejoin_seconds_per_draft_pick: default_factory_attributes(:football_league)[:seconds_per_draft_pick],
          leaguejoin_fractional_points: default_factory_attributes(:football_league)[:fractional_points],
          leaguejoin_negative_points: default_factory_attributes(:football_league)[:negative_points],
          leaguejoin_trade_deadline: default_factory_attributes(:football_league)[:trade_deadline],
          leaguejoin_playoff_teams: default_factory_attributes(:football_league)[:playoff_teams],
          leaguejoin_playoff_weeks: default_factory_attributes(:football_league)[:playoff_weeks],
          leaguejoin_playoff_start_date: default_factory_attributes(:football_league)[:playoff_start_date],
          leaguejoin_waiver_rules: default_factory_attributes(:football_league)[:waiver_rules],
          leaguejoin_starting_quarterbacks: default_factory_attributes(:football_league)[:starting_quarterbacks],
          leaguejoin_max_quarterbacks: default_factory_attributes(:football_league)[:max_quarterbacks],
          leaguejoin_starting_wide_receivers: default_factory_attributes(:football_league)[:starting_wide_receivers],
          leaguejoin_max_wide_receivers: default_factory_attributes(:football_league)[:max_wide_receivers],
          leaguejoin_starting_tight_ends: default_factory_attributes(:football_league)[:starting_tight_ends],
          leaguejoin_max_tight_ends_eq: default_factory_attributes(:football_league)[:max_tight_ends],
          leaguejoin_starting_running_backs: default_factory_attributes(:football_league)[:starting_running_backs],
          leaguejoin_max_running_backs: default_factory_attributes(:football_league)[:max_running_backs],
          leaguejoin_starting_kickers: default_factory_attributes(:football_league)[:starting_kickers],
          leaguejoin_max_kickers: default_factory_attributes(:football_league)[:max_kickers],
          leaguejoin_offensive_flex_positions: default_factory_attributes(:football_league)[:offensive_flex_positions],
          leaguejoin_starting_linebackers: default_factory_attributes(:football_league)[:starting_linebackers],
          leaguejoin_max_linebackers: default_factory_attributes(:football_league)[:max_linebackers],
          leaguejoin_starting_defensive_backs: default_factory_attributes(:football_league)[:starting_defensive_backs],
          leaguejoin_max_defensive_backs: default_factory_attributes(:football_league)[:max_defensive_backs],
          leaguejoin_starting_defensive_linemen: default_factory_attributes(:football_league)[:starting_defensive_linemen],
          leaguejoin_max_defensive_linemen: default_factory_attributes(:football_league)[:max_defensive_linemen],
          leaguejoin_starting_defensive_teams: default_factory_attributes(:football_league)[:starting_defensive_teams],
          leaguejoin_max_defensive_teams: default_factory_attributes(:football_league)[:max_defensive_teams],
          leaguejoin_defensive_flex_positions: default_factory_attributes(:football_league)[:defensive_flex_positions],
          leaguejoin_bench_positions: default_factory_attributes(:football_league)[:bench_positions],
          leaguejoin_points_per_passing_yard: default_factory_attributes(:football_league)[:points_per_passing_yard],
          leaguejoin_points_per_passing_td: default_factory_attributes(:football_league)[:points_per_passing_td],
          leaguejoin_points_per_interception: default_factory_attributes(:football_league)[:points_per_interception],
          leaguejoin_points_per_rushing_yard: default_factory_attributes(:football_league)[:points_per_rushing_yard],
          leaguejoin_points_per_rushing_td: default_factory_attributes(:football_league)[:points_per_rushing_td],
          leaguejoin_points_per_reception: default_factory_attributes(:football_league)[:points_per_reception],
          leaguejoin_points_per_reception_yard: default_factory_attributes(:football_league)[:points_per_reception_yard],
          leaguejoin_points_per_reception_td: default_factory_attributes(:football_league)[:points_per_reception_td],
          leaguejoin_points_per_return_td: default_factory_attributes(:football_league)[:points_per_return_td],
          leaguejoin_points_per_2_point_conversion: default_factory_attributes(:football_league)[:points_per_2_point_conversion],
          leaguejoin_points_per_fumbles_lost: default_factory_attributes(:football_league)[:points_per_fumbles_lost],
          leaguejoin_points_per_offensive_fumble_return_td: default_factory_attributes(:football_league)[:points_per_offensive_fumble_return_td],
          leaguejoin_field_goal_point_range: default_factory_attributes(:football_league)[:field_goal_point_range],
          leaguejoin_field_goal_miss_point_range: default_factory_attributes(:football_league)[:field_goal_miss_point_range],
          leaguejoin_points_per_point_after: default_factory_attributes(:football_league)[:points_per_point_after],
          leaguejoin_points_per_point_after_miss: default_factory_attributes(:football_league)[:points_per_point_after_miss],
          leaguejoin_points_per_defensive_sack: default_factory_attributes(:football_league)[:points_per_defensive_sack],
          leaguejoin_points_per_defensive_interception: default_factory_attributes(:football_league)[:points_per_defensive_interception],
          leaguejoin_points_per_fumble_recovery: default_factory_attributes(:football_league)[:points_per_fumble_recovery],
          leaguejoin_points_per_defensive_td: default_factory_attributes(:football_league)[:points_per_defensive_td],
          leaguejoin_points_per_safety: default_factory_attributes(:football_league)[:points_per_safety],
          leaguejoin_points_per_block_kick: default_factory_attributes(:football_league)[:points_per_block_kick],
          leaguejoin_points_per_kickoff_and_punt_return_td: default_factory_attributes(:football_league)[:points_per_kickoff_and_punt_return_td],
          leaguejoin_points_allowed_range: default_factory_attributes(:football_league)[:points_allowed_range],
          leaguejoin_url_like: default_factory_attributes(:football_league)[:url],
          leaguejoin_injured_reserve_positions: default_factory_attributes(:football_league)[:injured_reserve_positions],
          leaguejoin_points_per_dst_sack: default_factory_attributes(:football_league)[:points_per_dst_sack],
          leaguejoin_points_per_dst_interception: default_factory_attributes(:football_league)[:points_per_dst_interception],
          leaguejoin_points_per_dst_fumble_recovery: default_factory_attributes(:football_league)[:points_per_dst_fumble_recovery],
          leaguejoin_points_per_dst_td: default_factory_attributes(:football_league)[:points_per_dst_td],
          leaguejoin_points_per_dst_safety: default_factory_attributes(:football_league)[:points_per_dst_safety],
          leaguejoin_points_per_dst_block_kick: default_factory_attributes(:football_league)[:points_per_dst_block_kick],
          leaguejoin_points_per_solo_tackle: default_factory_attributes(:football_league)[:points_per_solo_tackle],
          leaguejoin_points_per_pass_defended: default_factory_attributes(:football_league)[:points_per_pass_defended],
          leaguejoin_points_per_tackle_assist: default_factory_attributes(:football_league)[:points_per_tackle_assist],
          leaguejoin_points_per_fumble_forced: default_factory_attributes(:football_league)[:points_per_fumble_forced],
          leaguejoin_points_per_dst_tackle_for_loss: default_factory_attributes(:football_league)[:points_per_dst_tackle_for_loss],
          leaguejoin_points_per_tackle_for_loss: default_factory_attributes(:football_league)[:points_per_tackle_for_loss],
          leaguejoin_points_per_turnover_return_yard: default_factory_attributes(:football_league)[:points_per_turnover_return_yard],
          leaguejoin_draft_type: default_factory_attributes(:football_league)[:draft_type],
          leaguejoin_this_param_should_not_be_used: 12345678900987654321
        }
      end

      it_behaves_like 'only returns the expected records'
    end

    context 'with all the hockey league params', :search do
      let!(:wrong_league)       { FactoryGirl.create(:hockey_league) }
      let!(:deleted_post_league){ FactoryGirl.create(:hockey_league, default_factory_attributes(:hockey_league)) }
      let!(:expected_league)    { FactoryGirl.create(:hockey_league, default_factory_attributes(:hockey_league)) }
      let!(:expected_post)      { FactoryGirl.create(:post, league: expected_league) }
      let!(:deleted_post)       { FactoryGirl.create :post, title: (expected_post.title + '__DELETED'), deleted_at: Time.now, league: deleted_post_league }
      let!(:wrong_league_post)  { FactoryGirl.create :post, title: (expected_post.title + '__WRONG_LEAGUE'), league: wrong_league }
      let!(:no_league_post)     { FactoryGirl.create :post, title: (expected_post.title + '__NO_LEAGUE'), league: nil }

      let(:expected_records){ [expected_post] }
      let(:mixed_up_title){ mix_up_string expected_post.title }
      let(:params) do
        {
          q: mixed_up_title,
          league_type: 'HockeyLeague',
          leaguejoin_teams: default_factory_attributes(:hockey_league)[:teams],
          leaguejoin_draft_date_gt: default_factory_attributes(:hockey_league)[:draft_date].beginning_of_day,
          leaguejoin_draft_date_lt: default_factory_attributes(:hockey_league)[:draft_date].end_of_day,
          leaguejoin_draft_order: default_factory_attributes(:hockey_league)[:draft_order],
          leaguejoin_url_like: default_factory_attributes(:hockey_league)[:url][0..-2].upcase, # test `ilike` functionality by removing last letter and capitalizing
          leaguejoin_seconds_per_draft_pick: default_factory_attributes(:hockey_league)[:seconds_per_draft_pick],
          leaguejoin_fractional_points: default_factory_attributes(:hockey_league)[:fractional_points],
          leaguejoin_negative_points: default_factory_attributes(:hockey_league)[:negative_points],
          leaguejoin_trade_deadline_gt: default_factory_attributes(:hockey_league)[:trade_deadline].beginning_of_day,
          leaguejoin_trade_deadline_lt: default_factory_attributes(:hockey_league)[:trade_deadline].end_of_day,
          leaguejoin_playoff_teams: default_factory_attributes(:hockey_league)[:playoff_teams],
          leaguejoin_playoff_weeks: default_factory_attributes(:hockey_league)[:playoff_weeks],
          leaguejoin_playoff_start_date_gt: default_factory_attributes(:hockey_league)[:playoff_start_date].beginning_of_day,
          leaguejoin_playoff_start_date_lt: default_factory_attributes(:hockey_league)[:playoff_start_date].end_of_day,
          leaguejoin_waiver_rules: default_factory_attributes(:hockey_league)[:waiver_rules],
          leaguejoin_starting_centers: default_factory_attributes(:hockey_league)[:starting_centers],
          leaguejoin_max_centers: default_factory_attributes(:hockey_league)[:max_centers],
          leaguejoin_starting_right_wings: default_factory_attributes(:hockey_league)[:starting_right_wings],
          leaguejoin_max_right_wings: default_factory_attributes(:hockey_league)[:max_right_wings],
          leaguejoin_starting_left_wings: default_factory_attributes(:hockey_league)[:starting_left_wings],
          leaguejoin_max_left_wings: default_factory_attributes(:hockey_league)[:max_left_wings],
          leaguejoin_starting_defensemen: default_factory_attributes(:hockey_league)[:starting_defensemen],
          leaguejoin_max_defensemen_gt: default_factory_attributes(:hockey_league)[:max_defensemen] - 1, # test `greater_than` functionality
          leaguejoin_max_defensemen_lt: default_factory_attributes(:hockey_league)[:max_defensemen] + 1, # test `less_than` functionality
          leaguejoin_starting_goaltenders: default_factory_attributes(:hockey_league)[:starting_goaltenders],
          leaguejoin_max_goaltenders: default_factory_attributes(:hockey_league)[:max_goaltenders],
          leaguejoin_utility_positions: default_factory_attributes(:hockey_league)[:utility_positions],
          leaguejoin_bench_positions: default_factory_attributes(:hockey_league)[:bench_positions],
          leaguejoin_score_goals: default_factory_attributes(:hockey_league)[:score_goals],
          leaguejoin_score_assists: default_factory_attributes(:hockey_league)[:score_assists],
          leaguejoin_score_plus_minus: default_factory_attributes(:hockey_league)[:score_plus_minus],
          leaguejoin_score_penalty_minutes: default_factory_attributes(:hockey_league)[:score_penalty_minutes],
          leaguejoin_score_powerplay_points: default_factory_attributes(:hockey_league)[:score_powerplay_points],
          leaguejoin_score_shorthanded_goals: default_factory_attributes(:hockey_league)[:score_shorthanded_goals],
          leaguejoin_score_game_winning_goals: default_factory_attributes(:hockey_league)[:score_game_winning_goals],
          leaguejoin_score_shots_on_goal: default_factory_attributes(:hockey_league)[:score_shots_on_goal],
          leaguejoin_score_faceoffs_won: default_factory_attributes(:hockey_league)[:score_faceoffs_won],
          leaguejoin_score_hits: default_factory_attributes(:hockey_league)[:score_hits],
          leaguejoin_score_wins: default_factory_attributes(:hockey_league)[:score_wins],
          leaguejoin_score_goals_against_average: default_factory_attributes(:hockey_league)[:score_goals_against_average],
          leaguejoin_score_saves: default_factory_attributes(:hockey_league)[:score_saves],
          leaguejoin_score_save_percentage: default_factory_attributes(:hockey_league)[:score_save_percentage],
          leaguejoin_score_points: default_factory_attributes(:hockey_league)[:score_points],
          leaguejoin_score_powerplay_goals: default_factory_attributes(:hockey_league)[:score_powerplay_goals],
          leaguejoin_score_powerplay_assists: default_factory_attributes(:hockey_league)[:score_powerplay_assists],
          leaguejoin_score_shorthanded_points: default_factory_attributes(:hockey_league)[:score_shorthanded_points],
          leaguejoin_score_shorthanded_assists: default_factory_attributes(:hockey_league)[:score_shorthanded_assists],
          leaguejoin_score_shooting_percentage: default_factory_attributes(:hockey_league)[:score_shooting_percentage],
          leaguejoin_score_faceoffs_lost: default_factory_attributes(:hockey_league)[:score_faceoffs_lost],
          leaguejoin_score_blocks: default_factory_attributes(:hockey_league)[:score_blocks],
          leaguejoin_score_games_started: default_factory_attributes(:hockey_league)[:score_games_started],
          leaguejoin_score_losses: default_factory_attributes(:hockey_league)[:score_losses],
          leaguejoin_score_goals_against: default_factory_attributes(:hockey_league)[:score_goals_against],
          leaguejoin_score_shots_against: default_factory_attributes(:hockey_league)[:score_shots_against],
          leaguejoin_draft_type: default_factory_attributes(:hockey_league)[:draft_type],
          leaguejoin_score_shifts: default_factory_attributes(:hockey_league)[:score_shifts],
          leaguejoin_score_time_on_ice: default_factory_attributes(:hockey_league)[:score_time_on_ice],
          leaguejoin_score_average_time_on_ice: default_factory_attributes(:hockey_league)[:score_average_time_on_ice],
          leaguejoin_score_hat_tricks: default_factory_attributes(:hockey_league)[:score_hat_tricks],
          leaguejoin_score_defensemen_points: default_factory_attributes(:hockey_league)[:score_defensemen_points],
          leaguejoin_score_special_teams_goals: default_factory_attributes(:hockey_league)[:score_special_teams_goals],
          leaguejoin_score_special_teams_assists: default_factory_attributes(:hockey_league)[:score_special_teams_assists],
          leaguejoin_score_special_teams_points: default_factory_attributes(:hockey_league)[:score_special_teams_points],
          leaguejoin_score_empty_net_goals_against: default_factory_attributes(:hockey_league)[:score_empty_net_goals_against],
          leaguejoin_score_minutes_played: default_factory_attributes(:hockey_league)[:score_minutes_played],
          leaguejoin_score_overtime_losses: default_factory_attributes(:hockey_league)[:score_overtime_losses],
          leaguejoin_score_goalie_winning_percentage: default_factory_attributes(:hockey_league)[:score_goalie_winning_percentage],
          leaguejoin_score_shutouts: default_factory_attributes(:hockey_league)[:score_shutouts],
          this_param_should_not_be_used: 12345678900987654321
        }
      end

      it_behaves_like 'only returns the expected records'
    end
  end

  def default_factory_attributes(league)
    @default_factory_attributes ||= [:football_league, :hockey_league].inject({}) do |hsh_a, league_type|
      hsh_a[league_type] = FactoryGirl.factory_by_name(league_type).definition.attributes.inject({}) do |hsh_b, factory|
        value = factory.instance_values['value']
        hsh_b[factory.instance_values['name']] = value.nil? ? factory.instance_values['block'].call : value
        hsh_b
      end
      hsh_a
    end
    @default_factory_attributes[league]
  end

  # Split string into groups of 4 characters.
  # Then, join those groups in random order with spaces.
  def mix_up_string(str)
    arr = str.scan(/.{1,4}/)
    4.times.map{ arr.sample }.join(' ')
  end
end