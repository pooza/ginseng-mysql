module Ginseng
  module MySQL
    class DSNTest < Test::Unit::TestCase
      def setup
        @dsn = DSN.parse('mysql2://mysql:nice_password@localhost:3306/pdns')
      end

      def test_new
        assert(@dsn.is_a?(DSN))
      end

      def test_scheme
        assert_equal(@dsn.scheme, 'mysql2')
      end

      def test_host
        assert_equal(@dsn.host, 'localhost')
      end

      def test_port
        assert_equal(@dsn.port, 3306)
      end

      def test_dbname
        assert_equal(@dsn.dbname, 'pdns')
      end

      def test_user
        assert_equal(@dsn.user, 'mysql')
      end

      def test_password
        assert_equal(@dsn.password, 'nice_password')
      end

      def test_to_h
        assert_equal(@dsn.to_h, {
          host: 'localhost',
          user: 'mysql',
          password: 'nice_password',
          dbname: 'pdns',
          port: 3306,
        })
      end
    end
  end
end
