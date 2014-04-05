Sequel.migration do
  up do
    create_table(:sessions) do
      String :uuid, null: false, length: 36, primary_key: true
      DateTime :updated_at, null: false
    end
  end

  down do
    drop_table(:sessions)
  end
end