class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.integer     :status
      t.references  :job, foreign_key: true
      t.integer     :external_reference
      t.string      :ad_description
      t.string      :local_hash
      t.timestamps
    end
  end
end
