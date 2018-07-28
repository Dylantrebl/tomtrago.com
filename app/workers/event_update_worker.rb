class EventUpdateWorker
  include Sidekiq::Worker

  TT_CALENDAR_URI = "https://gigs.gigatools.com/u/tomtrago.json?key="

  def perform
    key = ENV.fetch('GIGATOOLS_API_KEY')
    url = "#{TT_CALENDAR_URI}?key=#{key}"

    response = RestClient.get(url)
    resp_obj = JSON.parse(response, symbolize_names: true)
    results = resp_obj.second
    return unless results.present?

    results.each do |element|
      event = element[:event]
      continue unless event.present?
      ArtistEvent.transaction do
        artist_event = ArtistEvent.where(event_id: event[:id]).first_or_create
        artist_event.event_name = event[:name]
        artist_event.uri = event[:uri]
        artist_event.date = event[:eventdate]
        artist_event.venue_name = event[:venue]
        artist_event.city = event[:city]
        artist_event.location = event[:country]
        artist_event.save
      end
    end

  end
end
