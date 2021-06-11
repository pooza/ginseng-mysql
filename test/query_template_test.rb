module Ginseng
  module MySQL
    class QueryTemplateTest < Test::Unit::TestCase
      def setup
        @template = QueryTemplate.new('tables')
      end

      def test_new
        assert(@template.is_a?(QueryTemplate))
      end

      def test_param
        @template['schema'] = 'fuga'
        assert_equal(@template.params[:schema], 'fuga')
        @template[:schema] = 'hogehoge'
        assert_equal(@template.params[:schema], 'hogehoge')
      end

      def test_params
        @template.params = {'schema' => 'hoge'}
        assert_equal(@template.params[:schema], 'hoge')
        @template.params = {schema: 'information_schema'}
        assert_equal(@template.params[:schema], 'information_schema')
      end

      def test_to_s
        @template.params = {schema: 'information_schema'}
        assert_equal(@template.to_s, %(SELECT * FROM information_schema.tables WHERE table_schema='information_schema'))
      end
    end
  end
end
