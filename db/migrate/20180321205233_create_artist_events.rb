class CreateArtistEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :artist_events do |t|
      t.string :name
      t.datetime :date
      t.string :venue_name
      t.string :event_name
      t.string :location
      t.string :city
      t.integer :event_id
      t.string :status
      t.string :uri
      t.string :event_type
      t.timestamps
    end
  end
end
