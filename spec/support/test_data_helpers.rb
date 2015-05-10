module TestDataHelpers
  
  def create_luke_skywalker(opts={})
    User.create!(
      username: 'Luke',
      email: 'Luke@star.wars',
      password: 'Skywalker',
      password_confirmation: 'Skywalker',
      admin: true
    )
  end

  def create_bill_murray(opts={})
    User.create!(
      username: 'Bill',
      email: 'Bill@Murray.com',
      password: 'Murray',
      password_confirmation: 'Murray',
      admin: false
    )
  end

  def create_a_league_post(opts={})
    user = opts[:user] || User.first || create_luke_skywalker
    league = FactoryGirl.create :football_league
    Post.create! title: Faker::Company.bs.titleize, user: user, league: league
  end
  
  def create_a_reply(opts={})
    user = opts[:user] || User.first || create_luke_skywalker
    post = opts[:post] || Post.first || create_a_league_post
    Reply.create! body: Faker::Lorem.paragraph, user: user, post: post
  end
end