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
            '-h', @dsn.host,
            '-u', @dsn.user,
            '--single-transaction',
            '--skip-dump-date',
            @dsn.dbname
          ])
          @command.env = {'MYSQL_PWD' => @dsn.password}
        end
        return @command
      end

      def exec
        command.exec
        raise "Bad status #{command.status}" unless command.status.zero?
        @dump = command.stdout
        @dump.gsub(/AUTO_INCREMENT=[0-9]+ /, '')
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
