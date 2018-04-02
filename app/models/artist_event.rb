class ArtistEvent < ApplicationRecord

  def formatted
    day = format('%02d', date.day)
    month = format('%02d', date.month)
    gig = event_type == 'Concert' ? venue_name : event_name
    "#{day}-#{month} <span class='location'>#{location}</span> #{gig}"
  end

end
