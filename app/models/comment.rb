class Comment < ApplicationRecord
  belongs_to :video
  default_scope { order(created_at: :desc) }

  validates :commenter, presence: true, length: { maximum: 28 }
  validates :body, presence: true, length: { minimum: 2, maximum: 300 }

  def username_taken?(user)
    unless user.present?
      if commenter.blank?
        return false
      elsif User.find_by(username: commenter)
        errors.add(:commenter, "has already been taken")
        return true
      else
        return false
      end
    end
  end
end
