class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid
  # attr_accessible :title, :body
  
  #=============================================================
  # self.find_for_facebook_oauth
  #=============================================================
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
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
                            email:'ares1015@hotmail.com',
                            password:Devise.friendly_token[0,20]
                         })
    end
    return( user )
  end

end
