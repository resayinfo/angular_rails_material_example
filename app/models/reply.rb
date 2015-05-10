class Reply < ActiveRecord::Base
  self.table_name = :posts

  ## relations
  belongs_to :user
  belongs_to :post

  ## validations
  validates_presence_of :body, :user_id, :post_id

  ## delegations
  delegate :username, to: :user, prefix: true

  ## constants
  API_RESPONSE_VALUES = [
    :id, :user_id, :body, :post_id, :created_at, :updated_at
  ]

  default_scope { where(arel_table[:post_id].not_eq(nil)) }

  def self.deleted
    where(arel_table[:deleted_at].not_eq(nil))
  end

  def soft_delete!
    self.deleted_at = Time.now
    save
  end

  def deleted?
    deleted_at.present?
  end

  def serializable_hash(options={})
    options = {
      only: API_RESPONSE_VALUES
    }.update(options)
    super(options)
  end
end