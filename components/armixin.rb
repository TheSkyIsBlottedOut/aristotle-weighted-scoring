=begin
  ActiveRecord mixin.
  Score Returns should be floats.


=end

module PL
  module Aristotle
    module ARMixin
      attr_accessor :scorekeeper
      def self.extended(m)
        raise "Invalid Aristotle Mixin!" unless m.kind_of?(ActiveRecord::Base)
        m.scorekeeper = PL::Aristotle::Scorekeeper.new
      end
      
      def tally_score(args)
        args = {:group => "Default", :group_title => nil, :tag => "Unknown Quantity", :weight => 10, :score => 10, :message => "---"}.merge(args)
        self.scorekeeper.add_group(args[:group], args[:group_title])
        self.scorekeeper.set_weight(args[:group], args[:tag], args[:weight])
        self.scorekeeper.set_score(args[:group], args[:tag], args[:score], args[:message])
      end
      
      def score_presence_of(md)
        v = read_attribute(md)
        return [0.0, "Data not present or empty."] if v.to_s.empty?
        return [100.0, "Data present."]
      end
      
      def score_combined_presence_of(*md)
        ct = md.reject {|x| read_attribute(x).to_s.empty?}.length
        return [((ct.to_f / md.length) * 100.0), "#{ct} of #{md.length} fields present."]
      end
      
      def score_format_of(md, arglist)
        v = read_attribute(md).to_s
        arglist.each do |val, rgx, msg|
          return [val, msg] if v =~ rgx
        end
        return [0.0, "Format is invalid or unrecognizable."]
      end
      
      def score_numericality_of(md, arglist)
        v = read_attribute(md)
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
      
      def score_recency_of_update
        case self.updated_at.to_i
        when 0..(6.months.ago.to_i)
          [0.0, "Listing is delinquent."]
        when (6.months.ago.to_i)..(3.months.ago.to_i)
          [25.0, "Listing has not been updated for 3-6 months."]
        when (3.months.ago.to_i)..(2.months.ago.to_i)
          [50.0, "Listing has not been updated recently."]
        when (2.months.ago.to_i)..(1.month.ago.to_i)
          [75.0, "Listing has not been updated in the past month."]
        when (1.month.ago.to_i)..(1.week.ago.to_i)
          [90.0, "Listing has been updated in the past month."]
        else
          [100.0, "Listing has been updated recently."]
        end
      end
    end
  end
end