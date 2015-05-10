module LeagueLike
  ALL_LEAGUE_CLASSES = [FootballLeague, BaseballLeague, HockeyLeague]
  SERPENTINE_ORDER = 'Serpentine'

  def self.included(base)
    ## relationships
    base.has_many :posts, as: :league
    base.validates_presence_of :name

    ## constants
    # unless base.const_defined?(:SERPENTINE_ORDER)
    #   base.const_set :SERPENTINE_ORDER, SERPENTINE_ORDER
    # end
  end
end