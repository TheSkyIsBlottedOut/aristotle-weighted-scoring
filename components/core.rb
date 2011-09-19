=begin
  Core scorekeeper class

=end

module PL
  module Aristotle
    class Core
      def initialize(obj)
        @sample = obj
        corrupt(@sample)
      end
      
      def process
        raise "Process Has Not Been Extended!"
      end
      
      def score(grp, tag, wt = 10, val = 0, msg = '---')
        args = {:group => grp, :tag => tag, :weight => wt, :score => (val.to_f * (wt.to_f / 100.0)), :message => msg}
        @sample.tally_score(args)
      end
      
      def itemize
        @sample.scorekeeper.itemize
      end
      
      def title_for(k)
        @sample.scorekeeper.group_names[k]
      end
      
      def scorekeeper
        @sample.scorekeeper
      end
      
      def corrupt(obj)
        # Feel the power of evil
        obj.extend(PL::Aristotle::ARMixin)
      end
      
      def score_divide(val1, val2, ranges)
        score_value((val1.to_f / [val2.to_f, 0.001].max), ranges)
      end
      
      def score_value(val, arglist)
        v = val.to_f
        return [0.0, "Number is not entered."] if v.nil?
        v = v.to_f
        arglist.each do |val, cp, msg|
          if cp.is_a?(Range)
            return [val, msg] if cp.include?(v)
          elsif cp.is_a?(Numeric)
            return [val, msg] if v >= cp
          elsif cp.is_a?(Proc)
            return [val, msg] if cp.call(v)
          end
        end
        return [0.0, "Number is unacceptable or out of range."]
      end      
    end
  end
end