module Ginseng
  module MySQL
    class DumperTest < Test::Unit::TestCase
      def setup
        @dumper = Dumper.new
        @dumper.dest = File.join(
          Environment.dir,
          'tmp/cache',
          "#{Time.now.to_s.adler32}.sql",
        )
      end

      def test_dsn
        assert_kind_of(DSN, @dumper.dsn)
      end

      def test_command
        assert_kind_of(Ginseng::CommandLine, @dumper.command)
      end

      def test_exec
        @dumper.exec
        assert(File.exist?(@dumper.dest))
        @dumper.compress
        assert(File.exist?(@dumper.dest))
        assert(@dumper.dest.end_with?('.gz'))
      end
    end
  end
end
