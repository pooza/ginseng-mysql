module Ginseng
  module MySQL
    module Package
      def environment_class
        return Environment
      end

      def package_class
        return Package
      end

      def config_class
        return Config
      end

      def logger_class
        return Logger
      end

      def database_class
        return Database
      end

      def query_template_class
        return QueryTemplate
      end

      def self.name
        return 'ginseng-mysql'
      end

      def self.version
        return Config.instance['/package/version']
      end

      def self.url
        return Config.instance['/package/url']
      end
    end
  end
end
