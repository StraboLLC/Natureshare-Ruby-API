class CreateCaptures < ActiveRecord::Migration
  def change
    create_table :captures do |t|
      t.string :title
      t.string :token
      t.string :latitude
      t.string :longitude
      t.string :heading
      t.string :description
      t.datetime :taken_at
      t.string :media_type
      t.string :orientation
      t.boolean :encoding_finished
      t.boolean :mp4_finished
      t.boolean :webm_finished

      t.timestamps
    end
  end
end
