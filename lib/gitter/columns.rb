require 'active_support/concern'
require 'gitter/columns/column'
require 'gitter/columns/column_spec'
#require 'will_paginate'
#require 'will_paginate/active_record'
#require 'will_paginate/array'
  
module Gitter
  module Columns
    extend ActiveSupport::Concern
  
    included do
      self.class_attribute :column_specs, :instance_reader => false, :instance_writer => false
      self.column_specs = {}

      after_initialize :initialize_columns
      alias_method_chain :scope, :columns
    end
  
    module ClassMethods
      # adds a column to be displayed
      #
      # Example:
      #
      # column :birthday 
      # displays :birthday of the model
      #
      # A header may be specified by :header:
      #
      # column :birthday, :header => 'Birthday'
      #
      # Supply a block to computed the column's data
      #
      # column(:year, :header => 'Year') do |model|
      #   model.birthday.strftime("%Y")
      # end
      #
      def column( name, opts = {}, &block )
        self.column_specs = self.column_specs.merge name => ColumnSpec.new(name, opts, &block)
      end
    end
  
    def scope_with_columns( ordered = nil )
      @scope_with_columns ||= @order_column ? @order_column.ordered : scope_without_columns(ordered)
    end
 
    #def paginate
    #  @paginate ||= ordered.scope.paginate @paginate_hash
    #end
 
    def headers
      @headers ||= columns.map &:header
    end
 
    def row_for(model)
      columns.map{|c| c.cell model }
    end
 
    def rows( driver = self.scope )
      driver.map do |model| 
        @decorator.decorate model
        row_for model
      end
    end
 
    def columns
      @columns ||= self.class.column_specs.map{|name, spec| Column.new(self,spec) }
    end

    private

    def initialize_columns
      if order = @params[:order]
        if column_spec = self.class.column_specs[:"#{order}"] 
          @order_column = Column.new(self, column_spec)
        else
          raise ArgumentError, "invalid order column #{order}"
        end 
      else
        @order_column = nil
        raise ArgumentError, ':desc given but no :order' if @params[:desc] 
      end

      #@paginate_hash = { :per_page => @params.delete(:per_page){30}, :page => @params.delete(:page){1} }
    end
 
   end
 
end
