require 'mechanize'

class LeagueScraper < Mechanize
  class UrlError < StandardError; end
  class PrivateLeagueError < StandardError;end
  class SettingsNotFoundError < StandardError;end
  class ScoringTypeError < StandardError; end

  class << self
    def scrape_league_attributes!(url)
      validate_scraper_for_url!(url)
      scraper_subclass_for_url(url).new{ |agent|
        agent.user_agent_alias = 'Mac Safari'
      }.scrape_league_attributes!(url)
    end

    def readable_league_type
      @readable_league_type ||= name.gsub(/Scraper/,'').gsub(/::/,' ')
    end

    def league_class
      @league_class ||= const_get("#{readable_league_type.split(' ').last}League")
    end


    private

    def validate_scraper_for_url!(url)
      return nil if scraper_subclass_for_url(url)
      raise UrlError, "url must be for one of the following: #{ALL_LEAGUE_SCRAPERS.map(&:readable_league_type).join(', ')}"
    end

    def scraper_subclass_for_url(url)
      if self.name == 'LeagueScraper'
        klass = nil
        ALL_LEAGUE_SCRAPERS.each do |ls|
          if url =~ Regexp.new(ls::URL)
            return klass = ls
          end
        end
        klass
      else
        self
      end
    end
  end


  def scrape_league_attributes!(incoming_url)
    @url = incoming_url.dup

    format_url!
    get url

    validate_page!
    map_league_attributes!
    filter_league_attributes!
    league_attributes_map
  end

  def filter_league_attributes!
    @league_attributes_map ||= {}
    @league_attributes_map.reverse_merge! default_league_attributes
    @league_attributes_map.merge!(
      url: url,
      scraped_league_type: readable_league_type
    )
  end


  private
  attr_reader :url, :league_attributes_map

  def validate_page!
    unless page_present?
      raise LeagueScraper::SettingsNotFoundError, "no settings found at #{self.class.readable_league_type} url"
    end
  end

  def page_present?;end

  def default_league_attributes
    @default_league_attributes ||= self.class.league_class.new.attributes.symbolize_keys.except(
      :id, :created_at, :updated_at
    )
  end

  def readable_league_type
    @readable_league_type ||= self.class.readable_league_type
  end

  def format_url!
    base_url  = self.class::URL
    url_regex = Regexp.new ".*#{base_url}"
    path      = url.gsub! url_regex, ''

    if path.nil?
      type_name = self.class.name.gsub('Scraper','').gsub('::',' ')
      raise LeagueScraper::UrlError, "#{type_name} url must include '#{base_url}'"
    end

    @url = ['http://', base_url, path].join
  end

  def boolean_if_present(value)
    unless value.nil?
      !['no','false','0'].include? value.to_s.downcase
    end
  end

  def inverse_if_present(value_string)
    1 / value_string.scan(/\d+/)[0].to_f if value_string
  end

  def float_if_present(value_string)
    value_string.to_f if value_string
  end

  def iso8601_if_present(value_string)
    value_string.to_datetime.iso8601 if value_string
  end

  def integer_if_present(value_string)
    value_string.to_i if value_string
  end

  def match_subpattern(all_values, subpattern)
    all_values.scan Regexp.new("(^|\s)#{subpattern}(,|$)")
  end
end