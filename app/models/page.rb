class Page < ApplicationRecord
  validates :title, presence: true
  validates :published, inclusion: { in: [true, false] }, default: false
  validates :order, presence: true

  before_validation :set_order, if: -> { !order? }

  private

  def set_order
    curr_max_order = Page.all.maximum(:order) || -1
    self.order = curr_max_order + 1
  end
end
