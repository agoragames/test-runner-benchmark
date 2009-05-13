require 'test/unit/ui/console/testrunner.rb'
require 'test/unit/ui/testrunnermediator.rb'
module Test
  module Unit
    module UI
      module Console
        class TestRunner
          NUMBER_OF_TESTS_TO_SHOW_IN_OUTPUT_FOR_BENCHMARKS = 10
          def attach_to_mediator_with_benchmarking(*args)
            attach_to_mediator_without_benchmarking
            
            @@benchmark_results = {} unless defined?(@@benchmark_results)
            @mediator.add_listener(Test::Unit::UI::TestRunnerMediator::FINISHED) do |value|
              x = @@benchmark_results.sort { |l,r| l.last <=> r.last }.reverse
              nl
              puts x[0..NUMBER_OF_TESTS_TO_SHOW_IN_OUTPUT_FOR_BENCHMARKS].collect { |s| s.last.to_s.ljust(13) + s.first}.join("\n")
              nl
              puts "longest test name : #{x.collect(&:first).sort { |l,r| l.size <=> r.size }.reverse.first}"
              nl
            end

            @mediator.add_listener(Test::Unit::TestCase::FINISHED) { |value| @@benchmark_results[value] = Time.now - @@benchmark_results[value] }
            @mediator.add_listener(Test::Unit::TestCase::STARTED)  { |value| @@benchmark_results[value] = Time.now }
          end
          
          alias_method_chain :attach_to_mediator, :benchmarking
        end
      end
    end
  end
end