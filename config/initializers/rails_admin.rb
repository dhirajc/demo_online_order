RailsAdmin.config do |config|

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    edit do
      field :firstname
      field :lastname
      field :email
      field :password
      field :password_confirmation
    end
  end

  config.model Food do
    edit do
      # For RailsAdmin >= 0.5.0
      field :name
      field :description, :ck_editor
      field :short_description, :ck_editor
      field :category
      field :food_image
      # For RailsAdmin < 0.5.0
      # field :description do
      #   ckeditor true
      # end
    end
  end

  config.model Category do
    edit do
      # For RailsAdmin >= 0.5.0
      field :title
      field :description, :ck_editor
      include_all_fields
    end
  end
  
  


    # To Hide Unwanted Tables from admin dashboard
  hidden_model = ['AddressType','Cart','CartItem','Invoice','ItemType','Shipment','ShippingCategory','ShippingMethod','ShippingZone']
    hidden_model.each do |hidden|
      config.model hidden do
       visible false
      end
    end

end
