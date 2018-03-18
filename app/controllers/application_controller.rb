class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @pages = Page.where(published: true).order(:title)
  end
end
