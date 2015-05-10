module Yahoo
  class Scraper < LeagueScraper
    def self.credentials
      @credentials ||= SITE_CREDENTIALS[:yahoo]
    end

    private

    def validate_page!
      if page.at('head/title').text == 'Sign in to Yahoo'
        raise LeagueScraper::PrivateLeagueError, "cannot scrape settings of a private #{self.class.readable_league_type} league"
      end

      super
    end

    def page_present?
      settings_hash.present?
    end

    def last_week_counts?
      true
    end

    def playoff_info
      @playoff_info ||= begin
        info = settings_value('Playoffs:').split(' teams)')[0].split(' (')
        {
          weeks: info[0].scan(/\d+/),
          teams: info[1]
        }
      end
    end

    def scrape_playoff_weeks
      playoff_info[:weeks].count
    end

    def scrape_playoff_start_date
      @scrape_playoff_start_date ||= begin
        weeks_from_end_of_season = if last_week_counts?
          scrape_playoff_weeks
        else
          scrape_playoff_weeks + 1
        end

        DateTime.parse(self.class::LAST_WEEK_START_DATE) - weeks_from_end_of_season.weeks
      end
    end

    def settings_hash
      @settings_hash ||= hashify_table_body page.at("#settings-table tbody")
    end

    def roster_positions
      @roster_positions ||= settings_value('Roster Positions:')
    end

    def position_count(position)
      match_subpattern(roster_positions, position).count
    end

    def table_offset
      Rails.env == 'production' ? 0 : 1
    end

    def settings_value(field_name)
      settings_hash[field_name]
    end

    def scrape_waiver_rules(*fields)
      fields.map do |title|
        "#{title.gsub(/:/,'')}: #{settings_value(title)}"
      end.join(', ')
    end

    def hashify_table_body(table_body, key_col=0, value_col=2)
      return {} if table_body.nil?

      parsed_table = table_body.children.map do |row|
        td = row.children
        next unless key = td[key_col+table_offset]
        [key.text.strip, td[value_col+table_offset].text.strip]
      end.compact

      Hash[parsed_table]
    end
  end
end