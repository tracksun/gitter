require 'gitter/utils'

module Gitter

  class FacetData
    include Utils

    attr_reader :facet, :value, :count
    delegate :grid, :name, :to => :facet
    delegate :h, :to => :grid

    def initialize facet, value, count 
      @facet, @value, @count = facet, value, count 
    end

    def params
      { name => value }
    end

    def selected?
      @selected ||= facet.selected_value == value.to_s
    end

    def link
      h = grid.h
      p = grid.params.dup 
      p[name] = value.nil? ? '' : value
      p = grid.scoped_params p
      p[:page] = 1

      value_class = selected? ? 'facet_value_selected' : 'selected' 
      value_tag = h.content_tag :span, (value.nil? ? '-' : value), class: value_class
      value_tag = h.link_to value_tag, url_for(p)

      if selected? or not facet.selected?
        count_tag = h.content_tag :span, "(#{count})", :class => 'facet_count'
        count_tag = h.link_to count_tag,  url_for(p.merge(:show=>true))
      else
        count_tag = ''
      end

      h.content_tag :span, (value_tag + count_tag), {:class => 'facet_entry'}, false
    end

    def to_s
      "#{name}:#{value}=#{count}"
    end

  end

  class Facet
    attr_reader :filter
    delegate :grid, :name, :to => :filter

    def initialize filter
      @filter = filter
    end

    def label
      filter.label or grid.translate(:facets, name)
    end

    def selected_value
      @selected_value ||= grid.selected_value filter
    end

    def selected?
      !!selected_value
    end

    def data opts = {}
      value_to_count = filter.counts
      puts "FFFFFFFF #{self}. value_to_count=#{value_to_count.inspect}"
      values = opts[:include_zeros] ? filter.distinct_values(grid.driver) : value_to_count.keys
      values.map do |value|
        FacetData.new self, value, (value_to_count[value]||0)
      end
    end

    def to_s
      "#{self.class}(#{name},label=#{label})"
    end
  end

end
