module Gitter

  class ColumnFilter < AbstractFilter

    attr_reader :columns

    def initialize grid, name, opts = {}
      @columns = [opts[:column]||opts[:columns]||name].flatten
      super
    end

    def apply driver, *args
      opts = args.extract_options!

      raise ArgumentError, "too many arguments #{args.inspect}" unless args.size == 1
      value = args.first

      return driver if value.blank?

      attr_values = columns.inject({}){|memo,column| memo[column] = value; memo}
      driver.where attr_values, exact(opts), ignore_case(opts), format
    end

    def counts
      if columns.size == 1
        grid.driver.unordered.group(columns.first).count
      else
        super
      end
    end

    def distinct_values
      if columns.size == 1
        grid.driver.unordered.distinct_values(columns.first)
      else
        super
      end
    end

  end

end 