class CreateEventsGuestsJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :events, :guests do |t|
       t.index [ :event_id, :guest_id ]
       t.index [ :guest_id, :event_id ]
    end
  end
end
