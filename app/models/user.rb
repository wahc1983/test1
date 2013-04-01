class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, 
	 :omniauth_providers => [:facebook, :twitter],:authentication_keys => [:login]
  # Setup accessor
  attr_accessor :login
  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :provider, :uid, :login

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
Rails.logger.debug( 'Before Find' )
  def self.find_first_by_auth_conditions(warden_conditions)
Rails.logger.debug( 'inside Find' )
      conditions = warden_conditions.dup
srghryhrtyh
     if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
     else
      where(conditions).first
     end
Rails.logger.debug( 'after Find' )   
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
      user = User.create( { #name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20]
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
      user = User.create( { #name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:nil,
                            password:Devise.friendly_token[0,20]
                         })
    end
    return( user )
  end


  
  #=============================================================
  # self.find_for_database_authentication
  #=============================================================

def self.find_for_database_authentication(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login).downcase
    where(conditions).where('$or' => [ {:username => /^#{Regexp.escape(login)}$/i}, {:email => /^#{Regexp.escape(login)}$/i} ]).first
  else
    where(conditions).first
  end
end 

end
