class PagesController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @pages = Page.all
    @dates = ArtistEvent.order(:date).all.map { |event| formatted_event event + "</br>\n" }
    if @pages
      render json: @pages, status: :ok
    else
      render status: :unprocessable_entity
    end
  end

  private

  def formatted_event(artist_event)
    day = artist_event.date.day
    month = format '%02d', first: artist_event.date.month
    location = artist_event.location
    gig = artist_event.event_type == 'concert' ? artist_event.venue_name : artist_event.event_name
    "#{day}-#{month} #{location} #{gig}"
  end
end
