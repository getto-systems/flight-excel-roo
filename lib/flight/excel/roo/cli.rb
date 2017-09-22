require "thor"
require "json"
require "roo"

module Flight::Excel::Roo
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "read opts", "read excel file"
    def read(opts)
      data = JSON.parse(ENV["FLIGHT_DATA"])
      opts = JSON.parse(opts)

      data.each do |info|
        input = File.join([opts["src"], info["name"]])
        output = File.join([opts["dest"], info["name"]])

        begin
          Parser.new(output).parse(
            input: input,
            sheet: opts["sheet"],
            header: opts["header"],
            require_cols: opts["require_cols"],
            exclude_data: opts["exclude_data"],
          )
        rescue TypeError => e
          say "file type not allowed: #{e.message}"
          exit 105
        rescue RangeError => e
          say "sheet not found: #{e.message}"
          exit 104
        rescue Roo::HeaderRowNotFoundError => e
          say "header not found: #{e.message}"
          exit 104
        rescue => e
          say "error: #{e.message}"
          exit 1
        end
      end

      say JSON.generate(data)
    end
  end
end
