# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]

  private
  def respond_with(current_user, _opts = {})
    @token = request.env["warden-jwt_auth.token"]
    if(@token)
      headers["Authorization"] = @token

      render json: {
        status: {
          code: 200, message: "Logged in successfully.",
          token: @token,
          data: {
            user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }
        }
      }, status: :ok
    else
      render json: {
        status: { message: "User couldn't be login. #{current_user.errors.full_messages.to_sentence}" }
      },
      status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ").last,
      Rails.application.credentials.devise_jwt_secret_key!).first

      current_user = User.find(jwt_payload["sub"])

      if current_user
        render json: {
          status: 200,
          message: "Logout successfully!" 
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    else
      render json: {
          status: 401,
          message: "Authorization token is missing."
        }, status: :unauthorized
    end    
  end
end
