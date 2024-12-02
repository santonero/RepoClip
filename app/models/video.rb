class Video < ApplicationRecord
  has_one_attached :clip
  has_one_attached :thumbnail
  has_many :comments, dependent: :destroy

  validates :title, presence: true, uniqueness: { allow_blank: true }, length: { maximum: 30 }
  validates :description, length: { maximum: 550 }
  validates :clip, presence: true
  validates :thumbnail, presence: true
  validate :correct_video_type
  validate :correct_image_type
  validate :correct_clip_size
  validate :correct_image_size

  private

  def correct_video_type
    if clip.attached? && !clip.content_type.in?(%w(video/mp4 video/webm))
      errors.add(:clip, "must be a MP4 or WEBM")
    end
  end

  def correct_image_type
    if thumbnail.attached? && !thumbnail.content_type.in?(%w(image/jpeg image/png image/webp))
      errors.add(:thumbnail, "must be a JPEG, PNG or WEBP")
    end
  end

  def correct_clip_size
    if clip.attached? && clip.byte_size > 150.megabytes
      errors.add(:clip, "should be less than 150MB")
    end
  end

  def correct_image_size
    if thumbnail.attached? && thumbnail.byte_size > 2.megabytes
      errors.add(:thumbnail, "should be less than 2MB")
    end
  end
end
