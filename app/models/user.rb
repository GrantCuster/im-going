class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :image, :description, :fb_id, :fb_token

  has_many :listings, :dependent => :destroy
  has_many :intentions, :dependent => :destroy

  def to_json(options = {})
    super(options.merge(:only => [ :id, :email, :username, :image, :description ]))
  end

  def self.new_with_session(params, session)
    logger.debug 'session new'
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.info
    if user = self.find_by_email(data.email)
      user
    else # Create a user with a stub password.
      self.create(:email => data.email, :password => Devise.friendly_token[0,20], :fb_id => 12, :username => data.name, :image => data.image, :fb_token => access_token.credentials.token) 
    end
  end

end
