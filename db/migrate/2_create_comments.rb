migration 2, :create_comments do
  up do
    create_table(:comments) do
      column(:id, Integer, :serial => true)
      column(:post_id, Integer)
      column(:name, String)
      column(:email, String)
      column(:website, String)
      column(:body, Text)
    end
  end

  down do
    drop_table(:comments)
  end
end
