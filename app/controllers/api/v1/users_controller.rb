# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController

      # def find
      #   puts "------> #{params}"
      #   @user = User.find_by(email: params[:auth][:email])
      #   if @user
      #     render json: @user
      #   else
      #     @errors = @user.errors.full_messages
      #     render json: @errors
      #   end
      # end
      #
      # def set_user
      #   @user = User.find_by(id: params[:id])
      # end

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

    end
  end
end
