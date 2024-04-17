class CreateGuesses < ActiveRecord::Migration[7.1]
  def change
    create_table :guesses do |t|
      t.references :player, null: false, foreign_key: true
      t.references :treasure, null: false, foreign_key: true
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6
      t.integer :distance_from_treasure
      t.boolean :winner, default: false

      t.timestamps
    end
  end
end
