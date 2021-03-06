require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module FantasyLeagueFinder
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += [
      "#{config.root}/lib",
      "#{config.root}/lib/abilities",
      "#{config.root}/lib/mechanize",
      "#{config.root}/lib/param_filters",
      "#{config.root}/lib/query_filters",
      "#{config.root}/lib/serializers"
    ]


    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    # include Bower components in compiled assets
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components', 'javascripts')

    # via https://gist.github.com/afeld/5704079

    # We don't want the default of everything that isn't js or css, because it pulls too many things in
    config.assets.precompile.shift

    config.assets.initialize_on_precompile = false

    # Explicitly register the extensions we are interested in compiling
    config.assets.precompile.push(Proc.new do |path|
      File.extname(path).in? [
       '.html', '.erb', '.haml',
       '.png',  '.gif', '.jpg', '.jpeg', '.svg',
       '.eot',  '.otf', '.svc', '.woff', '.ttf',
      ]
    end)
  end
end
