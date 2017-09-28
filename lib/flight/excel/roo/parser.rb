require "json"
require "roo"
require "roo-xls"

module Flight::Excel::Roo
  class Parser
    def initialize(output)
      FileUtils.mkdir_p(File.dirname(output))
      @output_file = output
    end

    def parse(input:,sheet:,header:,require_cols:,exclude_data:)
      open

      sheet = parser(input).sheet(sheet)

      case header
      when Hash
        sheet.each(header) do |data|
          if data != header
            out data, require_cols: require_cols, exclude_data: exclude_data
          end
        end
      when Array
        map = nil
        sheet.each do |row|
          unless map
            map = to_header_map(header,row)
          else
            data = map.map{|i,key| [key,row[i]]}.to_h
            out data, require_cols: require_cols, exclude_data: exclude_data
          end
        end
        unless map
          raise Roo::HeaderRowNotFoundError
        end
      end

      close
    end

    private

      def open
        @output = File.open(@output_file, "w")
      end
      def close
        @output.close
      end

      def parser(input)
        case File.extname(input)
        when ".xls"
          Roo::Excel
        else
          Roo::Excelx
        end.new(input)
      end

      def to_header_map(header,row)
        header_index = 0
        map = nil
        row.each_with_index do |value,i|
          if header_match?(header[header_index].last,value)
            map ||= []
            map << [i,header[header_index].first]
            header_index += 1
          end
        end
        map
      end
      def header_match?(title,value)
        if title.start_with?("~")
          Regexp.new(title[1..-1]).match?(value)
        else
          title == value
        end
      end

      def out(data, require_cols:, exclude_data:)
        if isValidData?(data, require_cols: require_cols, exclude_data: exclude_data)
          @output.puts JSON.generate(data)
        end
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
