class EventUpdateWorker
  include Sidekiq::Worker

  TT_CALENDAR_URI = "https://api.songkick.com/api/3.0/artists/1892865/calendar.json"

  def perform
    key = ENV.fetch('SONGKICK_API_KEY')
    url = "#{TT_CALENDAR_URI}?apikey=#{key}"

    response = RestClient.get(url)
    resp_obj = JSON.parse(response).deep_symbolize_keys
    results = resp_obj[:resultsPage][:results]
    return unless results[:event]

    results[:event].each do |event|
      ArtistEvent.transaction do
        artist_event = ArtistEvent.where(event_id: event[:id]).first_or_create
        artist_event.status = event[:status]
        artist_event.event_name = event[:displayName]
        venue = event[:venue]
        if venue
          artist_event.venue_name = venue[:displayName]
          artist_event.location = venue[:metroArea][:displayName] if venue[:metroArea]
        end
        artist_event.uri = event[:uri]
        artist_event.date = event[:start][:date] if event[:start]
        artist_event.event_type = event[:type]
        artist_event.save
      end
    end

  end
end
