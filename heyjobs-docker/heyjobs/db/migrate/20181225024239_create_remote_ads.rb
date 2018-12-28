class CreateRemoteAds < ActiveRecord::Migration[5.1]
  def change
    create_table :remote_ads do |t|
      t.integer     :reference
      t.integer     :status
      t.string      :description
      t.string      :remote_hash
      t.timestamps
    end
  end
end
