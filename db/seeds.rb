# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
Post.destroy_all
LeagueLike::ALL_LEAGUE_CLASSES.map &:destroy_all

User.create!(
  username: 'Luke',
  email: 'Luke@star.wars',
  password: 'Skywalker',
  password_confirmation: 'Skywalker'
)

User.create!(
  username: 'admin',
  email: 'admin@admin.com',
  password: 'adminadmin',
  password_confirmation: 'adminadmin',
  admin: true
)

user_ids = FactoryGirl.create_list(:user, 20).map(&:id)

20.times do
  league = FactoryGirl.create [:football_league, :hockey_league, :baseball_league].sample
  FactoryGirl.create :post, user_id: user_ids.sample, league: league
end