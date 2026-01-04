module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate!, only: [:register, :login]
      
        def register
        user = User.new(register_params)
        user.role ||= "user"

        if user.save
          token = JwtService.encode({ user_id: user.id, role: user.role })
          render json: { token:, user: user_payload(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = JwtService.encode({ user_id: user.id, role: user.role })
          render json: { token:, user: user_payload(user) }
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      private

      def register_params
        params.require(:user).permit(:email, :password, :password_confirmation, :role)
      end

      def user_payload(user)
        { id: user.id, email: user.email, role: user.role }
      end
    end
  end
end
