module Ginseng
  module MySQL
    class Dumper
      attr_accessor :dsn, :dest

      def initialize(params = {})
        @dsn = Database.dsn
      end

      def command
        unless @command
          @command = CommandLine.new([
            'mysqldump',
            '--host', @dsn.host || '127.0.0.1',
            '--port', @dsn.port.to_s || '3306',
            '--user', @dsn.user,
            '--databases', @dsn.dbname,
            '--single-transaction',
            '--skip-dump-date'
          ])
          @command.env = {'MYSQL_PWD' => @dsn.password} if @dsn.password
        end
        return @command
      end

      def exec
        unless @dump
          command.exec
          raise "Bad status #{command.status}" unless command.status.zero?
          @dump = command.stdout
        end
        return @dump
      end

      def save
        raise '"dest" undefined' unless dest
        exec unless @dump
        File.write(dest, @dump)
      end

      def compress
        save unless File.exist?(dest)
        Ginseng::Gzip.compress(dest)
        @dest = "#{@dest}.gz"
      end
    end
  end
end
