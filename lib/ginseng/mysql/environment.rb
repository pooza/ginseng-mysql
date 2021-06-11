module Ginseng
  module MySQL
    class Environment < Ginseng::Environment
      def self.name
        return File.basename(dir)
      end

      def self.dir
        return Ginseng::MySQL.dir
      end
    end
  end
end
