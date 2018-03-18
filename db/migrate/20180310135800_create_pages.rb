class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string :title, null: false # Display name in menu
      t.boolean :published, null: false, default: false
      t.string :content
      t.string :href # https://domain.tld/#href
      t.string :link # External link
      t.string :background_color_effect # Hex
      t.integer :order, unique: true
      t.timestamps
    end
  end
end
