class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

def twitter
Rails.logger.debug( 'Twitter Before Find' )
Rails.logger.debug( User.all.size.to_s )
        @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)
Rails.logger.debug( 'Twitter Before Persisted' )
Rails.logger.debug( User.all.size.to_s )
    if ( @user.persisted? )
Rails.logger.debug( 'Twitter Inside Persisted' )
      sign_in_and_redirect( @user, { :event => :authentication } ) 
      set_flash_message( :notice, :success, { :kind => "twitter" } ) if ( is_navigational_format? )
    else
Rails.logger.debug( 'Twitter Else Persisted' )
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to( new_user_registration_url )
    end
  end
  
def facebook
Rails.logger.debug( 'Facebook Before Find' )
Rails.logger.debug( User.all.size.to_s )
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
Rails.logger.debug( 'Facebook Before Persisted' )
Rails.logger.debug( User.all.size.to_s )

    if ( @user.persisted? )
Rails.logger.debug( 'Facebook Inside Persisted' )
      sign_in_and_redirect( @user, { :event => :authentication } ) #this will throw if @user is not activated
      set_flash_message( :notice, :success, { :kind => "Facebook" } ) if ( is_navigational_format? )
    else
Rails.logger.debug( 'Facebook Else Persisted' )
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to( new_user_registration_url )
    end
  end

  
end
