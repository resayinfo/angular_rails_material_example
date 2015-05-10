class Post < ActiveRecord::Base
  include PostSerializer

  ## relations
  belongs_to :user
  belongs_to :league, polymorphic: true
  has_many :replies
  accepts_nested_attributes_for :league

  ## validations
  validates_presence_of :title, :user_id
  validates :user_id, inclusion: {
                        in: ->(post) { [post.user_id_was] },
                        message: "cannot be changed" 
                      }, on: :update

  ## delegations
  delegate :username, to: :user, prefix: true

  ## callbacks
  after_save :delete_old_league, if: :league_changed?

  default_scope { where(post_id: nil) }

  def self.deleted
    where(arel_table[:deleted_at].not_eq(nil))
  end

  def self.active
    where(deleted_at: nil)
  end

  def soft_delete!
    self.deleted_at = Time.now
    save
  end

  def deleted?
    deleted_at.present?
  end

  def build_league(params)
    raise "Unknown league_type: #{league_type}" unless LeagueLike::ALL_LEAGUE_CLASSES.map(&:name).include?(league_type)

    if league_type_changed?
      self.league = league_type.constantize.new(params)
    else
      self.league.assign_attributes params
      self.league
    end
  end


  private

  def league_changed?
    league_id_changed? || league_type_changed?
  end

  def delete_old_league
    if !!league_id_was && league_type_was.present?
      old_league = league_type_was.constantize.find_by id: league_id_was
      old_league.delete if old_league
    end
  end
end