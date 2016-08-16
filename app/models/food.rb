class Food < ActiveRecord::Base
	belongs_to :category
	has_many :order_items
	has_many :orders, through: :order_items

	has_many :variants
	has_many :active_variants, -> { where(deleted_at: nil) },class_name: 'Variant'
  accepts_nested_attributes_for :variants,           reject_if: proc { |attributes| attributes['sku'].blank? }

	has_attached_file :food_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => ""
  validates_attachment_content_type :food_image, :content_type => /\Aimage\/.*\Z/

  validates :category_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :short_description, presence: true
  validate  :ensure_available

  def self.active
    where("foods.deleted_at IS NULL OR foods.deleted_at > ?", Time.zone.now)
    #  Add this line if you want the available_at to function
    #where("products.available_at IS NULL OR products.available_at >= ?", Time.zone.now)
  end

  def active(at = Time.zone.now)
    deleted_at.nil? || deleted_at > (at + 1.second)
  end

  def active?(at = Time.zone.now)
    active(at)
  end

  def activate!
    self.deleted_at = nil
    save
  end

  def price_range
    return @price_range if @price_range
    return @price_range = ['N/A', 'N/A'] if active_variants.empty?
    @price_range = active_variants.minmax {|a,b| a.price <=> b.price }.map(&:price)
  end

  # Answers if the product has a price range or just one price.
  #   if there is more than one price returns true
  #
  # @param [none]
  # @return [Boolean] true == there is more than one price
  def price_range?
    !(price_range.first == price_range.last)
  end

 private
    def has_active_variants?
      active_variants.any?{|v| v.is_available? }
    end

    def ensure_available
      if active? && deleted_at_changed?
        self.errors.add(:base, 'There must be active variants.')  if active_variants.blank?
        #self.errors.add(:base, 'Variants must have inventory.')   unless active_variants.any?{|v| v.is_available? }
        self.deleted_at = deleted_at_was if active_variants.blank? || !active_variants.any?{|v| v.is_available? }
      end
    end
end
