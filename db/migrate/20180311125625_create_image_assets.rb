class CreateImageAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :image_assets do |t|
      t.string :attachment

      t.timestamps
    end
  end
end
