class CreateParticipants < ActiveRecord::Migration[4.2]
  def change
    create_table :participants do |t|
      t.string :andrewid
      t.string :cardnumber

      t.timestamps
    end
  end
end
