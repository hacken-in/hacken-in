module StyleguideHelper

  def kss_section(section, &block)
    @section = @styleguide.section(section)
    modifiers = @section.modifiers

    @example_html = capture(&block)

    render(:partial => "styleguide_block", :locals => {
      :html => @example_html,
      :modifiers => modifiers})
  end

end
