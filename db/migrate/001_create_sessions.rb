Sequel.migration do
  up do
    create_table(:sessions) do
      String :uuid, null: false, size: 36, primary_key: true
      DateTime :updated_at, null: false
      String :status, size: 30, null: false
    end
  end

  down do
    drop_table(:sessions)
  end
end