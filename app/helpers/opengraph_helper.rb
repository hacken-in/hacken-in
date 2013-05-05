module OpengraphHelper

  def opengraph_data(data)
    data["og:title"] = "#{data["og:title"]} - hacken.in" unless data["og:title"].blank?
    @opengraph_page_data = (@opengraph_page_data || {}).merge(data)
  end

  def render_opengraph(data)
    @opengraph_page_data = (data || {}).merge(@opengraph_page_data || {})

    opengraph = @opengraph_page_data.keys.map do |key|
      tag(:meta, property: key, content: @opengraph_page_data[key])
    end.join("\n")

    meta = if !@opengraph_page_data["og:description"].blank?
      tag(:meta, name:"description", content: @opengraph_page_data["og:description"])
    end

    (opengraph + meta).html_safe
  end

end
