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

# TODO: migrate all test watchers to spec watchers
# guard 'test', drb: false do
#   watch(%r{lib/(.*)\.rb})      { |m| "test/#{m[1]}_test.rb" }
#   watch('test/test_helper.rb') { "test" }
#
#   watch(%r{app/controllers/(.*)\.rb})                { |m| "test/functional/#{m[1]}_test.rb" }
#   watch(%r{app/views/.*\.rb})                        { "test/integration" }
#   watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
#   watch('config/routes.rb')                          { "test/integration/routes_test.rb" }
# end

guard 'rspec' do
  watch(%r{spec/.*_spec\.rb})
  watch(%r{app/models/(.*)\.rb})                     { |m| "test/models/#{m[1]}_spec.rb" }
end
