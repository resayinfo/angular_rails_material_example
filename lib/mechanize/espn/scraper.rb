module Espn
  class Scraper < LeagueScraper
    private

    def last_week_counts?
      true
    end

    def playoff_info
      @playoff_info ||= begin
        info = playoff_settings_value('Playoff Teams').scan(/\d+/)
        {
          weeks: info[1].to_i,
          teams: info[0].to_i
        }
      end
    end

    def scrape_playoff_weeks
      playoff_info[:weeks]
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

    def scrape_waiver_rules(*fields)
      fields.map do |title|
        "#{title}: #{rules_value(title)}"
      end.join(', ')
    end
  end
end