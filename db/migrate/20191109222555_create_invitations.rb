class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.references :user, foreign_key: true
      t.boolean :accept
      t.boolean :viewed

      t.timestamps
    end
  end
end
