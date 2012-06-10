class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :image, :description, :fb_id, :fb_token, :tw_id, :tw_token, :tw_secret

  has_many :listings, :dependent => :destroy
  has_many :intentions, :dependent => :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :venues

  def serializable_hash(options = {})
    options = (options || {}).merge(:only => [:id, :username, :image, :description, :fb_id])
    hash = super options
    
    if options && options[:current_user]
      current_user = options[:current_user]
      if current_user.following?(self)
        hash.merge!(:followed_by_current_user => current_user.following?(self))
      end
    end
    
    if options && options[:include_private]
      hash[:email] = email
      hash[:fb_token] = fb_token
    end
       
    hash
  end

  # def self.new_with_session(params, session)
  #   logger.debug 'session new'
  # end

  def self.find_for_facebook_oauth(access_token)
    data = access_token.info
    if user = self.find_by_email(data.email)
      user.update_attributes(:fb_token => access_token.credentials.token, :fb_id => access_token.uid)
      user
    else # Create a user with a stub password.
      self.create(:email => data.email, :password => Devise.friendly_token[0,20], :fb_id => access_token.uid, :username => (data.name).gsub(/\s+/,""), :image => data.image, :fb_token => access_token.credentials.token)
    end
  end
  
  def self.find_for_twitter_oauth(access_token)
    data = access_token.info
    if user = self.find_by_tw_id(access_token.uid)
      user
    else
      session[:omniauth] = data
      redirect_to :root
    end
  end
  
  def self.check_twitter_or_create(options)
    access_token = options["session"]
    data = access_token.info
    params = options["params"]
    user_data = params["user"]
    
    if user = self.find_by_email((user_data["email"]).downcase!)
      user.update_attributes(:tw_token => access_token.credentials.token, :tw_secret => access_token.credentials.secret, :tw_id => access_token.uid)
      user
    else
      email = (user_data["email"])
      email.downcase!
      self.create(:email => email, :password => Devise.friendly_token[0,20], :tw_id => access_token.uid, :username => data.nickname, :image => data.image, :tw_token => access_token.credentials.token, :tw_secret => access_token.credentials.secret)
    end
  end
  
  def self.client(token)
    Koala::Facebook::API.new(token)
  end
  
  def self.init_twitter(token, secret)
    unless @twitter_user
      @twitter_user = Twitter::Client.new(:consumer_key => "YAY8FFbW6ssYwqY11OJFOQ",  :consumer_secret => "I5szFahp3K61YYJA7X6zJx813qWEhKow70nYfg3m4", :oauth_token => token, :oauth_token_secret => secret)
    end
    @twitter_user
  end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user).destroy
  end

end
