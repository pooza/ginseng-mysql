module Ginseng
  module MySQL
    class QueryTemplate < Ginseng::Template
      include Package

      def initialize(name)
        name += '.sql' unless name.end_with?('.sql')
        super
      end

      def params=(params)
        params.each do |k, v|
          params[k] = db.escape_string(v) if v.is_a?(String)
        end
        super
      end

      def []=(key, value)
        value = db.escape_string(value) if value.is_a?(String)
        super
      end

      def to_s
        return super.gsub(/\s+/, ' ').strip
      end

      private

      def db
        return database_class.instance
      end

      def dir
        return 'query'
      end
    end
  end
end
