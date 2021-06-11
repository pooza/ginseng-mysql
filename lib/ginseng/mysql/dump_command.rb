module Ginseng
  module MySQL
    class DumpCommand
      attr_accessor :user, :db, :dest, :gzip, :mode

      def initialize(params = {})
        @user = params[:user] || 'mysql'
        @db = params[:db]
        @dest = params[:dest]
        @gzip = true
        @gzip = params[:gzip] if params.key?(:gzip)
        @mode = params[:mode] || 0o600
      end

      def exec
        dump!
        gzip! if @gzip
        chmod! if @mode
      end

      private

      def gzip!
        Ginseng::Gzip.compress(@dest)
        @dest = "#{@dest}.gz"
      end

      def dump!
        command = CommandLine.new(['sudo', '-u', @user, 'pg_dump', @db])
        command.exec
        File.write(@dest, command.stdout)
      end

      def chmod!
        File.chmod(@mode, @dest)
      end
    end
  end
end
