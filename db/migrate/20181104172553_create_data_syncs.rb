class CreateDataSyncs < ActiveRecord::Migration[5.1]
  def change
    create_table :data_syncs do |t|
      t.references :dealership, foreign_key: true
      t.string :provider_id
      t.datetime :last_run_at

      t.timestamps
    end
  end
end
