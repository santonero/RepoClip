class Comment < ApplicationRecord
  belongs_to :video
  default_scope { order(created_at: :desc) }

  validates :commenter, presence: true, length: { maximum: 28 }
  validates :body, presence: true, length: { minimum: 2, maximum: 300 }
end
