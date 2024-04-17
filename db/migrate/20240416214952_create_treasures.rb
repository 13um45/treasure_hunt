class CreateTreasures < ActiveRecord::Migration[7.1]
  def change
    create_table :treasures do |t|
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :long, precision: 10, scale: 6
      t.text :hint
      t.boolean :found, default: false

      t.timestamps
    end
  end
end
