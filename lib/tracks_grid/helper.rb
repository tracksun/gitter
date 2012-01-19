module TracksGrid
  module Helper
    # dirty hack to avoid rails' sorted query in url
    def url_for( params )
      p = params.dup
      query = p.map{|key, value| value.to_query(key) } * '&'
      "#{h.url_for({})}?#{query}"
    end
  end
end
