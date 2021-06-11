module Ginseng
  module MySQL
    class CITestCaseFilter < Ginseng::TestCaseFilter
      include Package

      def active?
        return environment_class.ci?
      end
    end
  end
end
