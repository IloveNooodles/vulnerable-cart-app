class CreateThisIsVerySecretLongTableNames < ActiveRecord::Migration[7.1]
  def change
    create_table :this_is_very_secret_long_table_names do |t|
      t.string :content

      t.timestamps
    end
  end
end
