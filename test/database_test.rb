module Ginseng
  module MySQL
    class DatabaseTest < Test::Unit::TestCase
      def setup
        @db = Database.instance
      end

      def test_connection
        assert(@db.connection.is_a?(Sequel::Database))
      end

      def test_escape
        assert_equal(@db.escape('あえ'), 'あえ')
        assert_equal(@db.escape(%(あえ")), %(あえ\\\"))
        assert_equal(@db.escape(%(あえ')), %(あえ\\'))
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
