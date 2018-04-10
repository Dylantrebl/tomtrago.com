class Page < ApplicationRecord
  validates :title, presence: true
  #validates :published, inclusion: { in: [true, false] }, default: false
  validates :order, presence: true

  before_validation :set_order, if: -> { !order? }


  def published=(value)
    self[:published] = (value == 'true' || value == true)
    p "setting to #{self[:published]}"
  end

  def published
    self[:published]
  end

  def link=(value)
    self[:link] = value
    self[:link] = nil if value.blank?
  end

  private

  def set_order
    curr_max_order = Page.all.maximum(:order) || -1
    self.order = curr_max_order + 1
  end
end
