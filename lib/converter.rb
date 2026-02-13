# frozen_string_literal: true

module Daniel70Weeks
  # Handles date conversions between Hebrew, Julian, Gregorian calendars
  # using Julian Day Numbers as the intermediate representation.
  module Converter
    module_function

    # Hebrew calendar epoch in JDN (Tishri 1, year 1 = October 7, 3761 BC Julian)
    HEBREW_EPOCH = 347_995

    # Convert Hebrew date to Julian Day Number
    # @param year [Integer] Hebrew year (e.g., 3317 for 444 BC)
    # @param month [Integer] Hebrew month (1 = Nisan, 7 = Tishri)
    # @param day [Integer] Day of month
    # @return [Integer] Julian Day Number
    def hebrew_to_jd(year, month, day)
      # Months in Hebrew year (Nisan = 1, but internally Tishri = 1 for calculations)
      months_in_year = hebrew_year_months(year)

      # Days before this year
      days = hebrew_calendar_elapsed_days(year)

      # Add days for months before this month
      if month < 7  # Nisan through Elul
        # Add all months from Tishri through Adar
        (7..months_in_year).each { |m| days += hebrew_month_days(year, m) }
        # Add months from Nisan up to (but not including) this month
        (1...month).each { |m| days += hebrew_month_days(year, m) }
      else  # Tishri through Adar
        (7...month).each { |m| days += hebrew_month_days(year, m) }
      end

      days + day + HEBREW_EPOCH
    end

    # Number of days elapsed from Hebrew epoch to Tishri 1 of given year
    def hebrew_calendar_elapsed_days(year)
      months_elapsed = (235 * ((year - 1) / 19)) +
                       (12 * ((year - 1) % 19)) +
                       ((7 * ((year - 1) % 19) + 1) / 19)

      parts_elapsed = 204 + 793 * (months_elapsed % 1080)
      hours_elapsed = 5 + 12 * months_elapsed +
                      793 * (months_elapsed / 1080) +
                      parts_elapsed / 1080
      parts = (parts_elapsed % 1080) + 1080 * (hours_elapsed % 24)

      day = 1 + 29 * months_elapsed + hours_elapsed / 24

      # Apply postponement rules (dehiyot)
      if parts >= 19440 ||
         (day % 7 == 2 && parts >= 9924 && !hebrew_leap_year?(year)) ||
         (day % 7 == 1 && parts >= 16789 && hebrew_leap_year?(year - 1))
        day += 1
      end

      day += 1 if [0, 3, 5].include?(day % 7)

      day
    end

    # Is the Hebrew year a leap year?
    def hebrew_leap_year?(year)
      ((7 * year + 1) % 19) < 7
    end

    # Number of months in Hebrew year
    def hebrew_year_months(year)
      hebrew_leap_year?(year) ? 13 : 12
    end

    # Number of days in a Hebrew month
    def hebrew_month_days(year, month)
      case month
      when 1  then 30  # Nisan
      when 2  then 29  # Iyar
      when 3  then 30  # Sivan
      when 4  then 29  # Tammuz
      when 5  then 30  # Av
      when 6  then 29  # Elul
      when 7  then 30  # Tishri
      when 8  then hebrew_cheshvan_days(year)  # Cheshvan (29 or 30)
      when 9  then hebrew_kislev_days(year)    # Kislev (29 or 30)
      when 10 then 29  # Tevet
      when 11 then 30  # Shevat
      when 12 then hebrew_leap_year?(year) ? 30 : 29  # Adar (or Adar I)
      when 13 then 29  # Adar II (leap years only)
      else raise ArgumentError, "Invalid Hebrew month: #{month}"
      end
    end

    # Days in Cheshvan for given year
    def hebrew_cheshvan_days(year)
      hebrew_year_days(year) % 10 == 5 ? 30 : 29
    end

    # Days in Kislev for given year
    def hebrew_kislev_days(year)
      hebrew_year_days(year) % 10 == 3 ? 29 : 30
    end

    # Total days in Hebrew year
    def hebrew_year_days(year)
      hebrew_calendar_elapsed_days(year + 1) - hebrew_calendar_elapsed_days(year)
    end

    # Convert Julian Day Number to Hebrew date
    # @param jd [Integer] Julian Day Number
    # @return [Hash] { year:, month:, day: }
    def jd_to_hebrew(jd)
      # Approximate year
      approx = ((jd - HEBREW_EPOCH) / 365.25).to_i + 1
      year = approx

      # Refine year - find year where jd falls after Tishri 1
      year += 1 while jd >= hebrew_to_jd(year + 1, 7, 1)

      # Determine starting month (Tishri if before Nisan, else Nisan)
      start_month = jd < hebrew_to_jd(year, 1, 1) ? 7 : 1

      # Find month
      month = start_month
      months_in_year = hebrew_year_months(year)

      loop do
        next_month = month == 6 ? 7 : (month == months_in_year ? 1 : month + 1)
        next_month_year = next_month == 1 && month >= 7 ? year : year
        break if jd < hebrew_to_jd(next_month_year, next_month, 1)

        month = next_month
        break if month == start_month # safety: looped all months
      end

      # Find day
      day = jd - hebrew_to_jd(year, month, 1) + 1

      { year: year, month: month, day: day }
    end

    # Convert Julian Day Number to Gregorian date
    # @param jd [Integer] Julian Day Number
    # @return [Date] Gregorian date
    def jd_to_gregorian(jd)
      Date.jd(jd, Date::GREGORIAN)
    end

    # Convert Julian Day Number to Julian calendar date
    # @param jd [Integer] Julian Day Number
    # @return [Date] Julian date
    def jd_to_julian(jd)
      Date.jd(jd, Date::JULIAN)
    end

    # Format a date, handling BC years
    # @param date [Date] Date to format
    # @param calendar [Symbol] :gregorian or :julian
    # @return [String] Formatted date string
    def format_date(date, calendar = :gregorian)
      year = date.year
      if year <= 0
        # Convert astronomical year to BC (year 0 = 1 BC, year -1 = 2 BC, etc.)
        "#{date.strftime('%B %-d')}, #{(1 - year)} BC (#{calendar.capitalize})"
      else
        "#{date.strftime('%B %-d')}, #{year} AD (#{calendar.capitalize})"
      end
    end

    # Hebrew month names
    HEBREW_MONTHS = {
      1 => "Nisan", 2 => "Iyar", 3 => "Sivan", 4 => "Tammuz",
      5 => "Av", 6 => "Elul", 7 => "Tishri", 8 => "Cheshvan",
      9 => "Kislev", 10 => "Tevet", 11 => "Shevat", 12 => "Adar", 13 => "Adar II"
    }.freeze

    # Format Hebrew date
    def format_hebrew(year, month, day)
      "#{HEBREW_MONTHS[month]} #{day}, #{year}"
    end
  end
end
