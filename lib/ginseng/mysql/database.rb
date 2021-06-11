require 'sequel'
require 'mysql2'
require 'facets/time'
require 'singleton'

module Ginseng
  module MySQL
    class Database
      include Singleton
      include Package
      attr_reader :connection

      def initialize
        @config = config_class.instance
        @logger = logger_class.new
        dsn = database_class.dsn
        raise Ginseng::DatabaseError, 'Invalid DSN' unless dsn.valid?
        @connection = Sequel.connect(dsn.to_s)
      rescue => e
        @logger.error(error: e)
        raise Ginseng::DatabaseError, e.message, e.backtrace
      end

      def escape_string(value)
        return Mysql2::Client.escape(value)
      end

      alias escape escape_string

      def create_sql(name, params = {})
        template = query_template_class.new(name)
        template.params = params
        return template.to_s
      rescue => e
        @logger.error(error: e, name: name, params: params)
        raise Ginseng::DatabaseError, e.message, e.backtrace
      end

      def execute(name, params = {})
        rows = nil
        sql = nil
        secs = Time.elapse do
          sql = create_sql(name, params)
          rows = @connection.fetch(sql).all.map(&:with_indifferent_access)
        end
        @logger.info(sql: sql, rows: rows.count, seconds: secs.round(3)) if loggable? || slow?(secs)
        return rows
      rescue => e
        @logger.error(error: e, sql: sql)
        raise Ginseng::DatabaseError, e.message, e.backtrace
      end

      alias exec execute

      def loggable?
        return environment_class.test?
      end

      def slow?(seconds)
        return @config['/mysql/slow_query/seconds'] < seconds
      end

      def self.dsn
        return DSN.parse(Config.instance['/mysql/dsn'])
      rescue Ginseng::ConfigError
        return nil
      end

      def self.connect
        return instance
      end

      def self.config?
        return dsn.present?
      end
    end
  end
end
