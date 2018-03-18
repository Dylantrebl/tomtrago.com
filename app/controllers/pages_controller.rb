class PagesController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @pages = Page.all
    if @pages
      render json: @pages, status: :ok
    else
      render status: :unprocessable_entity
    end
  end

end
