class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @pages = Page.where(published: true).order(:title)
    @dates = ArtistEvent
             .where('date > ?', Time.zone.now)
  end
end
