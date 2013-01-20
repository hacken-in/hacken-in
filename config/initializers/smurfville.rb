if defined?(Smurfville) != nil
  Smurfville.sass_directory = Rails.root.join('app', 'assets', 'stylesheets').to_s
  Smurfville.typography_sass_file = Rails.root.join('app', 'assets', 'stylesheets', 'base', '_typography.css.sass').to_s
end