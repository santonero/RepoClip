class Comment < ApplicationRecord
  belongs_to :video

  validates :commenter, presence: true
  validates :body, presence: true, length: { minimum: 2, maximum: 300 }
end
