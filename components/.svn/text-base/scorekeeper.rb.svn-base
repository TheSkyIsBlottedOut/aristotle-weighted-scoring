=begin
  Aristotle Scorekeeper\
  
  MODIFICATIONS NEEDED:
  Ignore weights if score for that weight is nil (i.e. N/A values)
=end

module PL
  module Aristotle
    class Scorekeeper
      attr_reader :group_names, :weights, :scores
      def initialize
        @group_names = Mash.new
        @weights = Mash.new(nil)
        @scores = Mash.new(nil)
      end
      
      def inspect
        "<#{self.class.name} - #{self.total_score}/#{self.total_weight}>"
      end
      
      def add_group(k, title = nil)
        unless @group_names[k]
          title ||= k.to_s
          @group_names[k] = title
          @weights[k] = Mash.new(0)
          @scores[k] ||= Mash.new(PL::Aristotle::Score.new)
        end
      end
      
      def set_weight(grp, k, w)
        @weights[grp][k] = w.to_i
      end
      
      def set_score(grp, k, score, message)
        @scores[grp][k] = PL::Aristotle::Score.new(score.to_i, message)
      end
      
      def group_weight(k)
        @weights[k].values.inject(0) {|s,i| s += i}
      end
      
      def group_score(k)
        @scores[k].values.inject(0) {|s,i| s += i.score}
      end
      
      def group_percentage(k)
        self.group_score(k).to_f / self.group_weight(k).to_f
      end
      
      def total_weight
        @weights.keys.inject(0) {|s,i| s += group_weight(i)}
      end
      
      def total_score
        @scores.keys.inject(0) {|s,i| s += group_score(i)}
      end
      
      def percentage
        self.total_score.to_f / self.total_weight
      end
      
      def itemize
        retval = Mash.new(nil)
        @group_names.each_pair do |k,v|
          retval[k] = @weights[k].collect do |k1, v1|
            {
              :group    => k,
              :tag      => k1,
              :weight   => v1,
              :score    => @scores[k][k1].score,
              :message  => @scores[k][k1].message
            }
          end
        end
        retval
      end
    end
  end
end


module PL
  module Aristotle
    class Score
      attr_accessor :score, :message
      def initialize(score = 0, message = nil)
        @score, @message = score, message
      end
      
      def to_i
        @score.to_i
      end
      
      def to_f
        @score.to_f
      end
    end
  end
end