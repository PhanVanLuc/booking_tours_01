class Tag < ApplicationRecord
  has_many :statistictag, class_name: :StatisticTag, foreign_key: :tag_id, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50}
end
