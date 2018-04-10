class ApplicationController < ActionController::Base


  def index
    @pages = Page.where(published: true).order(:title)
    @dates = ArtistEvent
             .order(:date)
             .where('date > ?', Time.zone.now)
  end
end
