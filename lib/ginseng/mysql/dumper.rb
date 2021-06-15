module Ginseng
  module MySQL
    class Dumper
      include Package
      attr_reader :dsn, :extra_args
      attr_accessor :dest

      def initialize(params = {})
        self.dsn = Database.dsn
        @dest = create_temp_path
        @extra_args = [
          '--single-transaction',
          '--skip-dump-date',
        ]
      end

      def dsn=(dsn)
        @dsn = dsn
        @command = nil
      end

      def command
        unless @command
          @command = CommandLine.new([
            'mysqldump',
            '--host', dsn.host || '127.0.0.1',
            '--port', dsn.port || 3306,
            '--user', dsn.user,
            '--databases', dsn.dbname,
            '--result-file', dest
          ])
          @command.args.concat(extra_args)
          @command.env = {'MYSQL_PWD' => dsn.password} if dsn.password
        end
        return @command
      end

      def exec
        command.exec
        raise "Bad status #{command.status}" unless command.status.zero?
        trim_auto_increment
      end

      def compress
        exec unless File.exist?(dest)
        Ginseng::Gzip.compress(dest)
        @dest = "#{dest}.gz"
      end

      private

      def create_temp_path
        return File.join(
          environment_class.dir,
          'tmp/cache/',
          "#{Time.now.to_s.adler32}.sql",
        )
      end

      def trim_auto_increment
        temp = create_temp_path
        File.open(temp, 'wb') do |output|
          File.foreach(dest) do |line|
            output.print(line.gsub(/AUTO_INCREMENT=[0-9]+ /, ''))
          end
        end
        File.rename(temp, dest)
      end
    end
  end
end
