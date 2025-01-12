class RecipesController < ApplicationController
    include SessionsHelper
    include RecipesHelper
    def new
        @recipe = Recipe.new
    end

    def create
        @recipe = Recipe.new(recipe_params)
        @recipe.user_id = session[:user_id]
        if recipe_params[:cover_image].nil?
            @recipe.cover_image.attach(io: File.open("#{Rails.root}/app/assets/images/kitten.jpg"), filename: 'kitten.jpg', content_type: 'image/jpg')
        end

        if @recipe.save
            flash[:success] = "Recipe uploaded"
            redirect_to '/home'
        else
            render '/recipes/error'
        end
    end


    def show 
        @recipe = Recipe.find(params[:id])
        @author = User.find_by(id: [@recipe.user_id])
        @user = User.find_by(id: session[:user_id])
        @comment = Comment.new
        @rating = Rating.new

        @current_rating = Rating.find_by(recipe_id: @recipe.id , user_id: @user.id )
    end

    def index
        @rating_ordered_recipes = Recipe.all.sort_by{|recipe| recipe.average_rating*(-1)}
        
    end
    
    private #helper functions only for METHODS within the class (.method.private_method)
      def recipe_params
        params.require(:recipe).permit(:title,:cover_image, :ingredients, :instructions)
      end

end
