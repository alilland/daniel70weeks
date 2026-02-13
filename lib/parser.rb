# frozen_string_literal: true

module Daniel70Weeks
  # Parses date strings into components for conversion
  module Parser
    module_function

    # Hebrew month name to number mapping
    HEBREW_MONTHS = {
      "nisan" => 1, "iyar" => 2, "sivan" => 3, "tammuz" => 4,
      "av" => 5, "elul" => 6, "tishri" => 7, "cheshvan" => 8,
      "kislev" => 9, "tevet" => 10, "shevat" => 11, "adar" => 12, "adar ii" => 13
    }.freeze

    # Parse a Hebrew date string like "Nisan 1, 444 BC"
    # @param input [String] Date string
    # @return [Hash] { hebrew_year:, month:, day: }
    def parse_hebrew_date(input)
      # Match: "Month Day, Year BC" or "Month Day, Year"
      pattern = /^(\w+(?:\s+\w+)?)\s+(\d+),?\s*(\d+)\s*(BC|AD|BCE|CE)?$/i
      match = input.strip.match(pattern)

      raise ArgumentError, "Cannot parse date: #{input}" unless match

      month_name = match[1].downcase
      day = match[2].to_i
      year = match[3].to_i
      era = (match[4] || "AD").upcase

      month = HEBREW_MONTHS[month_name]
      raise ArgumentError, "Unknown Hebrew month: #{match[1]}" unless month

      # Convert BC year to Hebrew year
      # Hebrew year 1 = 3761 BC
      # Nisan is in spring, so for "Nisan X, 444 BC":
      # - Tishri of Hebrew year 3317 = autumn 445 BC
      # - Nisan of Hebrew year 3317 = spring 444 BC
      hebrew_year = if era == "BC" || era == "BCE"
                      if month >= 7 # Tishri-Adar (fall/winter)
                        3761 - year + 1
                      else # Nisan-Elul (spring/summer)
                        3761 - year
                      end
                    else # AD/CE
                      if month >= 7
                        year + 3760
                      else
                        year + 3760 + 1
                      end
                    end

      { hebrew_year: hebrew_year, month: month, day: day }
    end
  end
end
