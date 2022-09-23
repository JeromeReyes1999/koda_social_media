class Comment < ApplicationRecord
  validates :content, presence: true
  belongs_to :post, optional: true
  belongs_to :group_post, optional: true
  belongs_to :user

  validates_presence_of :post, if: :group_post_id_blank?
  validates_presence_of :group_post, if: :post_id_blank?

  def group_post_id_blank?
    group_post_id.blank?
  end

  def post_id_blank?
    post_id.blank?
  end
end
