class Comment < ApplicationRecord
  belongs_to :video
  default_scope { order(created_at: :desc) }

  validates :commenter, presence: true, length: { maximum: 18 }
  validates :body, presence: true, length: { minimum: 2, maximum: 300 }
  validate :name_availability

  private

  def name_availability
    if !Current.user.present? && !commenter.blank? && User.exists?(username: commenter)
      errors.add(:commenter, "has already been taken")
    end
  end
end
