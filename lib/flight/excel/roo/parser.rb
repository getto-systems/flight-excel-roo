require "json"
require "roo"
require "roo-xls"

module Flight::Excel::Roo
  class Parser
    def initialize(output)
      FileUtils.mkdir_p(File.dirname(output))
      @output = File.open(output, "w")
    end

    def out(data)
      @output.puts JSON.generate(data)
    end

    def parse(input:,sheet:,header:,require_cols:,exclude_data:)
      parser(input).sheet(sheet).each(header) do |data|
        if isValidData?(data, require_cols: require_cols, exclude_data: exclude_data)
          out data
        end
      end
    end

    private

      def parser(input)
        case File.extname(input)
        when ".xls"
          Roo::Excel
        else
          Roo::Excelx
        end.new(input)
      end

      def isValidData?(data, require_cols:, exclude_data:)
        if !require_cols || !require_cols.all?{|col| data[col]}
          return false
        end
        if (exclude_data || []).any?{|k,v| data[k] == v}
          return false
        end
        return true
      end
  end
end
