class Category < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to  :parent_menu_item, class_name: 'Category', optional: true
  has_many    :child_menu_items, class_name: 'Category', foreign_key: :parent_id, dependent: :destroy
  validates :category_name, presence: true, length: { maximum: 50}
end