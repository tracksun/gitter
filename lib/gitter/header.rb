module Gitter

  class Header

    def self.blank
      new nil, HeaderSpec.blank
    end

    attr_reader :spec, :column
    delegate :name, :span, :column_spec, :to => :spec
    
    def initialize grid, spec, opts = {}
      @grid, @spec = grid, spec
      @column = opts[:column]
    end

    def label
      @label ||= case spec.content
	when false then ''
	when nil   then @grid.translate(:headers, name)
        else @grid.eval(spec.content)
      end
    end

    def link *args
      if column
        column.link label, *args
      else
	label
      end
    end

    def to_s
      "Header(#{name},#{span > 1 ? "#{span}," : ''}#{column_spec ? 'col,':''}label=#{label})"
    end
  end

end
