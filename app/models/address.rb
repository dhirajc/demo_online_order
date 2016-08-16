class Address < ActiveRecord::Base
  belongs_to  :state
  belongs_to  :country
  belongs_to  :address_type
  belongs_to  :addressable, :polymorphic => true

  validates :first_name,  :presence => true,
                          :format   => { :with => CustomValidators::Names.name_validator },       :length => { :maximum => 25 }
  validates :last_name,   :presence => true,
                          :format   => { :with => CustomValidators::Names.name_validator },       :length => { :maximum => 25 }
  validates :address1,    :presence => true,       :length => { :maximum => 255 }
  validates :city,        :presence => true,
                          :format   => { :with => CustomValidators::Names.name_validator },       :length => { :maximum => 75 }

  validates :zip_code,    :presence => true,       :length => { :minimum => 5, :maximum => 12 }
  
  before_validation :sanitize_data

  attr_accessor :replace_address_id # if you are updating an address set this field.
  before_create :default_to_active
  before_save :replace_address, if: :replace_address_id
  after_save  :invalidate_old_defaults


  def name
    [first_name, last_name].compact.join(' ')
  end

  # Will inactivate and save the address
  #
  # @param none
  # @ return [Boolean] true or error(error will only happen if there is a bad record in the db)
  def inactive!
    self.active = false
    save!
  end

  # hash of all the address db attributes except created_at, updated_at, id
  #
  # @param none
  # @ return [Hash] address db attributes except created_at, updated_at, id
  def address_attributes
    attributes.delete_if {|key, value| ["id", 'updated_at', 'created_at'].any?{|k| k == key }}
  end  

  # @ return [Hash] address attributes for a creditcard processor
  def cc_params
    { :name     => name,
      :address1 => address1,
      :address2 => address2,
      :city     => city,
      :zip      => zip_code#,
      #:phone    => phone
    }
  end
  def address_lines(join_chars = ', ')
    address_lines_array.join(join_chars)
  end


  def address_lines_array
    [address1, address2].delete_if{|add| add.blank?}
  end

  def city_state_zip
    [city_state_name, zip_code].join(' ')
  end

  def city_state_name
    [city, state_abbr_name].join(', ')
  end

  # Use this method to represent the "city, state.abbreviation"
  #
  # @param [none]
  # @return [String] "city, state.abbreviation"
  def state_country_name
    [state_abbr_name, country.try(:name)].compact.join(', ')
  end

  def state_abbr_name
    state ? state.abbreviation : state_name
  end
private
    def sanitize_data
      sanitize_name
      sanitize_city
      sanitize_zip_code
      sanitize_address
    end

    def default_to_active
      self.active ||= true
    end

    def sanitize_zip_code
      self.zip_code    = self.zip_code.strip    unless self.zip_code.blank?
    end

    def sanitize_city
      self.city        = self.city.strip        unless self.city.blank?
    end

    def sanitize_name
      sanitize_first_name
      sanitize_last_name
    end

    def sanitize_first_name
      self.first_name  = self.first_name.strip  unless self.first_name.blank?
    end

    def sanitize_last_name
      self.last_name   = self.last_name.strip   unless self.last_name.blank?
    end

    def sanitize_address
      sanitize_address1
      sanitize_address2
    end

    def sanitize_address1
      self.address1    = self.address1.strip    unless self.address1.blank?
    end

    def sanitize_address2
      self.address2    = self.address2.strip    unless self.address2.blank?
    end

  	def replace_address
  		Address.where(id: replace_address_id).update_all(active: false)
  	end
    
    def invalidate_old_defaults
      [:default, :billing_default].each do |attr|
        Address.where({
          addressable_type: addressable_type,
          addressable_id: addressable_id
        }).where("id <> ?", self.id).update_all(attr => false) if self[attr]
      end
    end	
end


