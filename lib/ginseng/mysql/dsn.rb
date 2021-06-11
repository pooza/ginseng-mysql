module Ginseng
  module MySQL
    class DSN < Ginseng::URI
      def dbname
        return path.sub(%r{^/}, '')
      end

      def valid?
        return absolute? && scheme == 'mysql2'
      end

      def to_h
        return {
          host: host,
          user: user,
          password: password,
          dbname: dbname,
          port: port,
        }
      end
    end
  end
end
