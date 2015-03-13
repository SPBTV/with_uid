require 'active_record'
require 'with_uid'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)
ActiveRecord::Base.connection
  .create_table('model_with_uids', temporary: true) do |t|
  t.string :name, :uid
end

class ModelWithUid < ActiveRecord::Base
  self.primary_key = :id
  include WithUid

  generate_uid
end
