class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :room_message, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true, null: false

      t.string :file, null: false
      t.string :content_type, null: false
      t.bigint :file_size, null: false

      t.timestamps
    end
  end
end
