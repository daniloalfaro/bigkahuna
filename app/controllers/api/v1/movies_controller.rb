# frozen_string_literal: true

module Api
  module V1
    class MoviesController < ApplicationController
      before_action :movie?, only: %i[update destroy show availability buy rent
                                      return]

      def index
        if current_user
          return (@movies = Movie.order_by_name.available) unless
            current_user.role == 'admin'

          @movies = Movie.order_by_name
          @movies = @movies.available   if params[:available].present?
          @movies = @movies.unavailable if params[:unavailable].present?
        else
          @movies = Movie.order_by_name.available
        end

        @movies = @movies.search(params[:q]) unless params[:q].blank?
        @movies = @movies.order_by_likes if params[:order_by_likes].present?

        p = params[:page].to_i <= 0 ? 1 : params[:page].to_i
        @movies = @movies.paginate(page: p, per_page: 5)

        response.headers['pagination'] = {
          total_pages: @movies.total_pages,
          current_page: @movies.current_page.to_i
        }.to_json
        render json: @movies.to_json
      end

      def show
        @movie_ = (@movie.image_attachment ? @movie.to_json(include: :image) : @movie.to_json)

        if current_user && current_user.role == 'admin' && params[:changes].present?
          @movie_ = if @movie.image_attachment
                      @movie.to_json(include: %i[image revisions])
                    else
                      @movie.to_json(include: :revisions)
                    end
        end
        render json: @movie_
      end

      def create
        return (render status: 401) unless current_user &&
                                           current_user.role == 'admin'

        @movie = Movie.new movie_params
        @movie.user_id = current_user.id
        return (render json: @movie.errors, status: 422) unless @movie.save

        render json: @movie.to_json(include: :image), status: :created
      end

      def update
        return (render status: 401) unless current_user &&
                                           current_user.role == 'admin'

        return (render status: 404) unless @movie

        @movie.assign_attributes(movie_params.reject { |_, v| v.blank? })
        @movie.user_id = current_user.id

        return (render json: @movie.errors, status: 422) unless @movie.save

        render json: @movie.to_json
      end

      def destroy
        return (render status: 401) unless current_user &&
                                           current_user.role == 'admin'

        return (render status: 404) unless @movie

        render status: 200 if @movie.destroy
      end

      def availability
        return (render status: 401) unless current_user &&
                                           current_user.role == 'admin'

        return (render status: 404) unless @movie

        unless @movie.toggle(:availability).save(validate: false)
          return (render json: @movie.errors, status: 422)
        end

        @movie_ = (@movie.image_attachment ? @movie.to_json(include: :image) : @movie.to_json)

        render json: @movie_
      end

      def buy
        return (render status: 401) unless current_user &&
                                           current_user.role == 'none'

        @quantity = params[:quantity].to_i
        return (render json: { message: 'That movie isn\'t in stock' }) unless
        @movie.check_stock('sale', @quantity)

        render status: 200 if @movie.checkout(current_user.id, @quantity)
      end

      def rent
        return (render status: 401) unless current_user &&
                                           current_user.role == 'none'

        @return_days = params[:return_days].to_i
        return (render json: { message: 'That movie isn\'t in stock' }) unless
        @movie.check_stock('rental')

        render status: 200 if @movie.lend(current_user.id, @return_days)
      end

      def return
        return (render status: 401) unless current_user &&
                                           current_user.role == 'none'

        unless Rent.where(movie_id: @movie.id, user_id: current_user.id).first
          return
        end

        @rent = Rent.where(movie_id: @movie.id, user_id: current_user.id, real_return_date: nil).first
        return (render status: 404) unless @rent

        if @rent.update(real_return_date: DateTime.now)
          @rent.check_return_dates
          render json: @rent.to_json, status: 200
        end
      end

      private

      def movie?
        @movie = Movie.exists?(params[:id]) ? Movie.find(params[:id]) : nil
      end

      def movie_params
        params.require(:movie).permit(:name,
                                      :description,
                                      :stock_sale,
                                      :stock_rental,
                                      :price_sale,
                                      :price_rental,
                                      :availability,
                                      :image)
      end
    end
  end
end
