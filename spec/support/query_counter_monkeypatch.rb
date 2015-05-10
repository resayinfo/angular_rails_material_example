module ActiveRecord
  class QueryCounter
    cattr_accessor :query_count do
      0
    end
    cattr_accessor :counting_queries do
      false
    end

    IGNORED_SQL = [
      /^PRAGMA (?!(table_info))/,
      /^SELECT currval/,
      /^SELECT CAST/,
      /^SELECT @@IDENTITY/,
      /^SELECT @@ROWCOUNT/,
      /^SAVEPOINT/,
      /^ROLLBACK/,
      /^RELEASE/,
      /^SHOW/,
      /^BEGIN/,
      /^COMMIT/
    ]

    IGNORED_NAMES = [
      /SCHEMA/,
      /CACHE/
    ]

    def call(name, start, finish, message_id, values)
      unless IGNORED_NAMES.any? { |r| values[:name] =~ r }
        if self.class.counting_queries && !IGNORED_SQL.any? { |r| values[:sql] =~ r }
          self.class.query_count += 1
        end
      end
    end
  end
end

ActiveSupport::Notifications.subscribe('sql.active_record', ActiveRecord::QueryCounter.new)

module ActiveRecord
  class Base
    def self.count_queries(&block)
      ActiveRecord::QueryCounter.query_count = 0
      ActiveRecord::QueryCounter.counting_queries = true
      yield
      ActiveRecord::QueryCounter.counting_queries = false
      ActiveRecord::QueryCounter.query_count
    end
  end
end