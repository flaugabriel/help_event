class CreateEventItems < ActiveRecord::Migration[5.2]
  def change
    create_table :event_items do |t|
      t.boolean :status
      t.references :event, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
