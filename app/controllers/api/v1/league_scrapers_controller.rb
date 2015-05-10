class Api::V1::LeagueScrapersController < Api::V1::ApiController
  skip_before_filter :ensure_authenticated

  # GET /league_scrapers/:url
  def show
    begin
      @league_scraper = LeagueScraper.scrape_league_attributes! params[:url]
      render json: {league_scraper: @league_scraper}, status: :ok
    rescue => e
      logger.debug "\n\n\n"
      logger.debug e
      logger.debug e.backtrace
      logger.debug "\n\n\n"
      render json: { errors: {e.class.name => [e.message]} }, status: :unprocessable_entity
    end
  end
end