# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/lib/.+_spec\.rb$})
  watch(%r{^lib/ace_of_spades/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('lib/ace_of_spades.rb') { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end

