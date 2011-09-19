=begin
  Aristotle is the scoring mechanism behind quality scores.
  
  Each scoring method should take a weight (the maximum number of points awarded),
  keep a running tally of the maximum score, and then return a final score as a fraction.


=end

module PL
  module Aristotle
    class << self
      def root
        @root ||= File.expand_path(File.dirname(__FILE__))
      end
    end
  end
end

['scorekeeper', 'armixin', 'core'].collect {|x| require PL::Aristotle.root / 'components' / x}