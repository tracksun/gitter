module Gitter

  class Column
    attr_reader :spec, :grid

    def initialize( grid, spec )
      @grid, @spec = grid, spec
    end

    def name
      spec.name
    end

    def params
      grid.params
    end

    def cell( model )
      if spec.block
        grid.eval spec.block, model
      else
        model.send(spec.attr||name)
      end
    end

    def ordered
      spec.ordered grid.driver, params[:desc]
    end

    def header
      case spec.header
      when false 
        ''
      when nil 
        grid.translate :headers, name
      else
        grid.eval spec.header
      end
    end

    # if current params contain order for this column then revert direction 
    # else add order_params for this column to current params
    def order_params
      @order_params ||= begin
        p = params.dup
        if ordered?
          p[:desc] = !desc?
        else
          p = p.merge :order => name, :desc => false 
        end
        p
      end
    end

    def desc?
      @desc ||= to_boolean params[:desc]
    end

    def ordered?
      @ordered ||= params[:order] == name.to_s
    end

    def link( opts = {} )
      img = order_img_tag(opts) 
      if spec.ordered?
        label = header
        label = h.content_tag :span, img + header if ordered?
        h.link_to label, order_params.merge(opts)
      else
        header 
      end 
    end

    private

    def h
     grid.h
    end

    def order_img_tag( opts = {} )
      desc_img = opts.delete(:desc_img){'sort_desc.gif'} 
      asc_img  = opts.delete(:asc_img){'sort_asc.gif'} 
      h.image_tag( desc? ? desc_img : asc_img)
    end

    def to_boolean(s)
      not (s && s.match(/true|t|1$/i)).nil?
    end
  end

end
