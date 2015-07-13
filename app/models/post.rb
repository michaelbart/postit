class Post < ActiveRecord::Base
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :post_categories
  has_many :comments
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable
  # rails will know the foreign_key is not post_id, instead it's voteable_type & voteable_id

  validates :title, presence: true, length: {minimum: 5} # title must exist, length >= 5
  validates :description, presence: true
  validates :url, presence: true, uniqueness: true

  def total_votes
    up_votes - down_votes
  end

  def up_votes # votes of the post that are true/the size
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

end
