guard 'pow' do
  watch('.powrc')
  watch('.powenv')
  watch('.rvmrc')
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
end

guard 'bundler' do
  watch('Gemfile')
end

guard 'rspec' do
  watch(%r{spec/.*_spec\.rb})
  watch(%r{lib/(.*)\.rb})                            { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{app/models/(.*)\.rb})                     { |m| "spec/models/#{m[1]}_spec.rb" }
end
