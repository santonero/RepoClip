class Video < ApplicationRecord
  has_one_attached :clip
  has_one_attached :thumbnail
  has_many :comments, dependent: :destroy

  validates :title, presence: true, uniqueness: { allow_blank: true }, length: { maximum: 30 }
  validates :description, length: { maximum: 550 }
  validates :clip, attached: true, content_type: ["video/mp4", "video/webm"], size: { less_than_or_equal_to: 75.megabytes }
  validates :thumbnail, attached: true, content_type: ["image/jpeg", "image/png", "image/webp"], size: { less_than_or_equal_to: 2.megabytes }
end
