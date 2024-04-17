class CreateTemporaryTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :temporary_tokens do |t|
      t.references :player, null: false, foreign_key: true
      t.string :hashed_token
      t.datetime :expiry
      t.boolean :enabled, default: false

      t.timestamps
    end
    add_index :temporary_tokens, :hashed_token, unique: true
  end
end
