class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, 
	 :omniauth_providers => [:facebook, :twitter],:authentication_keys => [:login2]
  # Setup accessor
  attr_accessor :login2
  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :login2
  validates :login, :uniqueness => {:message => "is already in use"}, :presence => {:message => "can't be empty"}


  before_validation :before_validation_handler
def before_validation_handler
 Rails.logger.debug( 'before_validation_handler' )
 puts "\nbefore_validation_handler\n\n"
end

  after_validation :after_validation_handler
def after_validation_handler
 Rails.logger.debug( 'after_validation_handler' )
 puts "\nafter_validation_handler\n\n"
end

 before_save :before_save_handler
def before_save_handler
 Rails.logger.debug( 'before_save_handler' )
 puts "\nbefore_save_handler\n\n"
end

 before_create :before_create_handler
def before_create_handler
 Rails.logger.debug( 'before_create_handler' )
 puts "\nbefore_create_handler\n\n"
end

 after_create :after_create_handler
def after_create_handler
 Rails.logger.debug( 'after_create_handler' )
 puts "\nafter_create_handler\n\n"
end

 after_save :after_save_handler
def after_save_handler
 Rails.logger.debug( 'after_save_handler' )
 puts "\nafter_save_handler\n\n"
end

 after_commit :after_commit_handler
def after_commit_handler
 Rails.logger.debug( 'after_commit_handler' )
 puts "\nafter_commit_handler\n\n"
end
 #=============================================================
 # self.find_first_by_auth_conditions
 #=============================================================

  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
     if login = conditions.delete(:login2)
        return( where(conditions).where(["lower(login) = :value or lower(email) = :value", { :value => login.downcase }]).first )
     else
      return( where(conditions).first )
     end
end

  
  #=============================================================
  # self.find_for_facebook_oauth
  #=============================================================
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    # 1. Buscar en la tabla "authentications".
    # 1.1. Si existe buscar el usuario relacionado y retornar ese usuario.
    # 1.2. Si no existe, crear el usuario con los datos suministrados por el proveedor incluyendo la authentication.
    user = User.where( { :provider => auth.provider, :uid => auth.uid } ).first
    unless( user )
      user = User.create( { provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                            #login : 
                         })
    end
    return( user )
  end


  #=============================================================
  # self.find_for_twitter_oauth
  #=============================================================

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where( { :provider => auth.provider, :uid => auth.uid } ).first
    unless( user )
      user = User.create( { provider:auth.provider,
                            uid:auth.uid,
			    login:auth.info.nickname,
                            email:auth.info.nickname+'@change.me',
                            password:Devise.friendly_token[0,20]
                            })
    end
    return( user )
  end

  #=============================================================
  # create_login_facebook
  #=============================================================

before_validation :create_login

  def create_login
Rails.logger.debug( 'create_login_facebook' )             
    email = self.email.split(/@/)
    login_taken = User.where( {:login => email[0]}).first
    unless login_taken
      return( self.login = email[0])
    else	
      return(self.login = self.email)
    end	       
  end

  #def self.find_for_database_authentication(conditions)
  #  return(self.where( {:login => conditions[:email]}).first || self.where({:email => conditions[:email]}).first)
  #end

end
