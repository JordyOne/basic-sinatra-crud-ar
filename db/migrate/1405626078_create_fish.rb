class CreateFish < ActiveRecord::Migration
  def up
    create_table :fish do |t|
      t.string :name
      t.string :users_id
    end
  end

  def down
    # add reverse migration code here
  end
end
