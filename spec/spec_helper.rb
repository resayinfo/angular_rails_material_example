ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'
require 'pry'
require 'vcr'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara::Screenshot.prune_strategy = { keep: 5 }

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

# driver options include: poltergeist, and poltergeist_debug
Capybara.configure do |config|
  config.default_selector  = :css
  config.default_driver    = :rack_test
  config.javascript_driver = :poltergeist
  config.default_wait_time = 5
end

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { record: :once }
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.color = true

  config.before(:suite) do
    if self.respond_to? :visit
      # HACK to force asset compilation in a Rack request so it's ready for
      # the Poltergeist request that otherwise times out.
      visit '/assets/test.css' # A streamlined css file for quicker tests.
      visit '/assets/application.js'
    end
  end

  config.after(:example, type: :feature) do
    # HACK to prevent Capybara::Poltergeist::TimeoutError
    sleep 0.1
  end

  config.include TestDataHelpers
  config.include JSONHelpers,     type: :controller
  config.include LoginHelpers,    type: :controller
  config.include CucumberHelpers, type: :feature
end
ActiveRecord::Migration.maintain_test_schema! if defined?(ActiveRecord::Migration)

# Faker does not support random dates
# https://github.com/stympy/faker/pull/73
# So lets extends Faker
# https://gist.github.com/rjackson/4694263
class Faker::Date
  def self.random
    Date.today-rand(10_000)
  end
end