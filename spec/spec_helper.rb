require 'pry'
require 'rspec'
require 'parslet'
require './lib/parser'
require './lib/transform'
require './lib/nodes'
require './lib/types'

# Really need to silence these hundreds of parslet warnings in a better way
class MyIO < StringIO
  def puts(*strs)
    strs.each do |str|
      if str =~ /warning: instance variable @.{1,20} not initialized/
      else
        $og_stderr.puts str
      end
    end
  end
end

RSpec.configure do |config|
  $og_stderr = $stderr
  config.before(:all) do
    $stderr = MyIO.new
  end
  config.after(:all) do
    $stderr = $og_stderr
  end
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true
  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
