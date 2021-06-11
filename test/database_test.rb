module Ginseng
  module MySQL
    class DatabaseTest < Test::Unit::TestCase
      def setup
        @db = Database.instance
      end

      def test_connection
        assert(@db.connection.is_a?(Sequel::Database))
      end

      def test_escape_string
        assert_equal(@db.escape_string('あえ'), 'あえ')
        assert_equal(@db.escape_string(%(あえ")), %(あえ\"))
        assert_equal(@db.escape_string(%(あえ')), %(あえ''))
      end

      def test_execute
        assert(@db.execute('tables', {schema: 'information_schema'}).present?)
        @db.execute('tables', {schema: 'information_schema'}).each do |row|
          assert(row.is_a?(Hash))
        end
      end
    end
  end
end
