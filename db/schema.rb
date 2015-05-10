# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150327015550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "baseball_leagues", force: true do |t|
    t.string   "name"
    t.integer  "teams"
    t.datetime "draft_date"
    t.string   "draft_order"
    t.integer  "seconds_per_draft_pick"
    t.boolean  "fractional_points"
    t.boolean  "negative_points"
    t.datetime "trade_deadline"
    t.integer  "playoff_teams"
    t.integer  "playoff_weeks"
    t.datetime "playoff_start_date"
    t.string   "waiver_rules"
    t.string   "url"
    t.string   "draft_type"
    t.integer  "teams_filled"
    t.decimal  "entry_fee",                         precision: 10, scale: 2
    t.integer  "starting_catchers"
    t.integer  "max_catchers"
    t.integer  "starting_first_basemen"
    t.integer  "max_first_basemen"
    t.integer  "starting_second_basemen"
    t.integer  "max_second_basemen"
    t.integer  "starting_third_basemen"
    t.integer  "max_third_basemen"
    t.integer  "starting_shortstops"
    t.integer  "max_shortstops"
    t.integer  "starting_left_fielders"
    t.integer  "max_left_fielders"
    t.integer  "starting_center_fielders"
    t.integer  "max_center_fielders"
    t.integer  "starting_right_fielders"
    t.integer  "max_right_fielders"
    t.integer  "starting_outfielders"
    t.integer  "max_outfielders"
    t.integer  "starting_utility_players"
    t.integer  "max_utility_players"
    t.integer  "starting_designated_hitters"
    t.integer  "max_designated_hitters"
    t.integer  "starting_pitchers"
    t.integer  "max_pitchers"
    t.integer  "starting_starting_pitchers"
    t.integer  "max_starting_pitchers"
    t.integer  "starting_relief_pitchers"
    t.integer  "max_relief_pitchers"
    t.integer  "bench_positions"
    t.integer  "disabled_list_positions"
    t.boolean  "score_hits"
    t.boolean  "score_extra_base_hits"
    t.boolean  "score_batting_averages"
    t.boolean  "score_slugging_percentage"
    t.boolean  "score_on_base_percentage"
    t.boolean  "score_total_bases"
    t.boolean  "score_runs_created"
    t.boolean  "score_singles"
    t.boolean  "score_doubles"
    t.boolean  "score_triples"
    t.boolean  "score_homeruns"
    t.boolean  "score_walks"
    t.boolean  "score_runs_scored"
    t.boolean  "score_runs_batted_in"
    t.boolean  "score_stolen_bases"
    t.boolean  "score_strikeouts"
    t.boolean  "score_ground_into_double_plays"
    t.boolean  "score_cycles"
    t.boolean  "score_errors"
    t.boolean  "score_earned_run_averages"
    t.boolean  "score_whips"
    t.boolean  "score_innings_pitched"
    t.boolean  "score_earned_runs"
    t.boolean  "score_wins"
    t.boolean  "score_losses"
    t.boolean  "score_saves"
    t.boolean  "score_blown_saves"
    t.boolean  "score_thrown_strikeouts"
    t.boolean  "score_hits_allowed"
    t.boolean  "score_walks_issued"
    t.boolean  "score_shutouts"
    t.boolean  "score_hit_batters"
    t.boolean  "score_complete_games"
    t.boolean  "score_no_hitters"
    t.boolean  "score_perfect_games"
    t.boolean  "score_on_base_percentages_against"
    t.boolean  "score_batting_averages_against"
    t.boolean  "score_strikeout_to_walk_ratios"
    t.boolean  "score_strikeouts_per_9_innings"
    t.boolean  "score_quality_starts"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "football_leagues", force: true do |t|
    t.string   "name",                                                                           null: false
    t.integer  "teams"
    t.datetime "draft_date"
    t.string   "draft_order"
    t.integer  "seconds_per_draft_pick"
    t.boolean  "fractional_points",                                              default: false, null: false
    t.boolean  "negative_points",                                                default: false, null: false
    t.datetime "trade_deadline"
    t.integer  "playoff_teams"
    t.integer  "playoff_weeks"
    t.datetime "playoff_start_date"
    t.string   "waiver_rules"
    t.integer  "starting_quarterbacks"
    t.integer  "max_quarterbacks"
    t.integer  "starting_wide_receivers"
    t.integer  "max_wide_receivers"
    t.integer  "starting_tight_ends"
    t.integer  "max_tight_ends"
    t.integer  "starting_running_backs"
    t.integer  "max_running_backs"
    t.integer  "starting_kickers"
    t.integer  "max_kickers"
    t.integer  "offensive_flex_positions"
    t.integer  "starting_linebackers"
    t.integer  "max_linebackers"
    t.integer  "starting_defensive_backs"
    t.integer  "max_defensive_backs"
    t.integer  "starting_defensive_linemen"
    t.integer  "max_defensive_linemen"
    t.integer  "starting_defensive_teams"
    t.integer  "max_defensive_teams"
    t.integer  "defensive_flex_positions"
    t.integer  "bench_positions"
    t.decimal  "points_per_passing_yard",               precision: 6,  scale: 3
    t.decimal  "points_per_passing_td",                 precision: 6,  scale: 3
    t.decimal  "points_per_interception",               precision: 6,  scale: 3
    t.decimal  "points_per_rushing_yard",               precision: 6,  scale: 3
    t.decimal  "points_per_rushing_td",                 precision: 6,  scale: 3
    t.decimal  "points_per_reception",                  precision: 6,  scale: 3
    t.decimal  "points_per_reception_yard",             precision: 6,  scale: 3
    t.decimal  "points_per_reception_td",               precision: 6,  scale: 3
    t.decimal  "points_per_return_td",                  precision: 6,  scale: 3
    t.decimal  "points_per_2_point_conversion",         precision: 6,  scale: 3
    t.decimal  "points_per_fumbles_lost",               precision: 6,  scale: 3
    t.decimal  "points_per_offensive_fumble_return_td", precision: 6,  scale: 3
    t.string   "field_goal_point_range"
    t.string   "field_goal_miss_point_range"
    t.decimal  "points_per_point_after",                precision: 6,  scale: 3
    t.decimal  "points_per_point_after_miss",           precision: 6,  scale: 3
    t.decimal  "points_per_defensive_sack",             precision: 6,  scale: 3
    t.decimal  "points_per_defensive_interception",     precision: 6,  scale: 3
    t.decimal  "points_per_fumble_recovery",            precision: 6,  scale: 3
    t.decimal  "points_per_defensive_td",               precision: 6,  scale: 3
    t.decimal  "points_per_safety",                     precision: 6,  scale: 3
    t.decimal  "points_per_block_kick",                 precision: 6,  scale: 3
    t.decimal  "points_per_kickoff_and_punt_return_td", precision: 6,  scale: 3
    t.string   "points_allowed_range"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "injured_reserve_positions"
    t.decimal  "points_per_dst_sack",                   precision: 6,  scale: 3
    t.decimal  "points_per_dst_interception",           precision: 6,  scale: 3
    t.decimal  "points_per_dst_fumble_recovery",        precision: 6,  scale: 3
    t.decimal  "points_per_dst_td",                     precision: 6,  scale: 3
    t.decimal  "points_per_dst_safety",                 precision: 6,  scale: 3
    t.decimal  "points_per_dst_block_kick",             precision: 6,  scale: 3
    t.decimal  "points_per_solo_tackle",                precision: 6,  scale: 3
    t.decimal  "points_per_pass_defended",              precision: 6,  scale: 3
    t.decimal  "points_per_tackle_assist",              precision: 6,  scale: 3
    t.decimal  "points_per_fumble_forced",              precision: 6,  scale: 3
    t.decimal  "points_per_dst_tackle_for_loss",        precision: 6,  scale: 3
    t.decimal  "points_per_tackle_for_loss",            precision: 6,  scale: 3
    t.decimal  "points_per_turnover_return_yard",       precision: 6,  scale: 3
    t.string   "draft_type"
    t.integer  "teams_filled"
    t.decimal  "entry_fee",                             precision: 10, scale: 2
  end

  create_table "hockey_leagues", force: true do |t|
    t.string   "name",                                                                     null: false
    t.integer  "teams"
    t.datetime "draft_date"
    t.string   "draft_order"
    t.integer  "seconds_per_draft_pick"
    t.boolean  "fractional_points",                                        default: false, null: false
    t.boolean  "negative_points",                                          default: false, null: false
    t.datetime "trade_deadline"
    t.integer  "playoff_teams"
    t.integer  "playoff_weeks"
    t.datetime "playoff_start_date"
    t.string   "waiver_rules"
    t.string   "url"
    t.integer  "starting_centers"
    t.integer  "max_centers"
    t.integer  "starting_right_wings"
    t.integer  "max_right_wings"
    t.integer  "starting_left_wings"
    t.integer  "max_left_wings"
    t.integer  "starting_defensemen"
    t.integer  "max_defensemen"
    t.integer  "starting_goaltenders"
    t.integer  "max_goaltenders"
    t.integer  "utility_positions"
    t.integer  "bench_positions"
    t.boolean  "score_goals",                                              default: false, null: false
    t.boolean  "score_assists",                                            default: false, null: false
    t.boolean  "score_plus_minus",                                         default: false, null: false
    t.boolean  "score_penalty_minutes",                                    default: false, null: false
    t.boolean  "score_powerplay_points",                                   default: false, null: false
    t.boolean  "score_shorthanded_goals",                                  default: false, null: false
    t.boolean  "score_game_winning_goals",                                 default: false, null: false
    t.boolean  "score_shots_on_goal",                                      default: false, null: false
    t.boolean  "score_faceoffs_won",                                       default: false, null: false
    t.boolean  "score_hits",                                               default: false, null: false
    t.boolean  "score_wins",                                               default: false, null: false
    t.boolean  "score_goals_against_average",                              default: false, null: false
    t.boolean  "score_saves",                                              default: false, null: false
    t.boolean  "score_save_percentage",                                    default: false, null: false
    t.boolean  "score_shutouts",                                           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "starting_flex_wings"
    t.integer  "starting_flex_forwards"
    t.integer  "injured_reserve_positions"
    t.integer  "max_inactives"
    t.boolean  "score_points",                                             default: false, null: false
    t.boolean  "score_powerplay_goals",                                    default: false, null: false
    t.boolean  "score_powerplay_assists",                                  default: false, null: false
    t.boolean  "score_shorthanded_points",                                 default: false, null: false
    t.boolean  "score_shorthanded_assists",                                default: false, null: false
    t.boolean  "score_shooting_percentage",                                default: false, null: false
    t.boolean  "score_faceoffs_lost",                                      default: false, null: false
    t.boolean  "score_blocks",                                             default: false, null: false
    t.boolean  "score_games_started",                                      default: false, null: false
    t.boolean  "score_losses",                                             default: false, null: false
    t.boolean  "score_goals_against",                                      default: false, null: false
    t.boolean  "score_shots_against",                                      default: false, null: false
    t.string   "draft_type"
    t.boolean  "score_shifts",                                             default: false, null: false
    t.boolean  "score_time_on_ice",                                        default: false, null: false
    t.boolean  "score_average_time_on_ice",                                default: false, null: false
    t.boolean  "score_hat_tricks",                                         default: false, null: false
    t.boolean  "score_defensemen_points",                                  default: false, null: false
    t.boolean  "score_special_teams_goals",                                default: false, null: false
    t.boolean  "score_special_teams_assists",                              default: false, null: false
    t.boolean  "score_special_teams_points",                               default: false, null: false
    t.boolean  "score_empty_net_goals_against",                            default: false, null: false
    t.boolean  "score_minutes_played",                                     default: false, null: false
    t.boolean  "score_overtime_losses",                                    default: false, null: false
    t.boolean  "score_goalie_winning_percentage",                          default: false, null: false
    t.integer  "teams_filled"
    t.decimal  "entry_fee",                       precision: 10, scale: 2
  end

  create_table "posts", force: true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "league_id"
    t.string   "league_type"
    t.integer  "post_id"
    t.string   "title"
  end

  add_index "posts", ["league_id", "league_type"], name: "index_posts_on_league_id_and_league_type", using: :btree
  add_index "posts", ["post_id"], name: "index_posts_on_post_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "username",                        null: false
    t.string   "email",                           null: false
    t.string   "password_digest"
    t.boolean  "admin",           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deactivated_at"
  end

end
