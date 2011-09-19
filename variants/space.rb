module PL
  module Aristotle
    module Analyst
      class Space < PL::Aristotle::Core
        @@pragma = {
          :price_per_sf => [
            [10.0, (0.00001)..(0.04), "Low lease price."],
            [100.0, (0.04)..20, "Lease price within range."],
            [10.0, 20.0001, "Lease price high."]
          ],
          :space_ranges => [
            [10.0, 0..200, "Size is very low."],
            [90.0, 200..500, "Acceptable size range (small)."],
            [100.0, 500..2000, "Acceptable size range (medium)."],
            [100.0, 2000..10000, "Acceptable size range (large)."],
            [30.0, 10000, "Very high square footage."]
          ]
        }

        def process
          score("Core", "Lease Price (Low)", 100, *@sample.score_numericality_of(:sf_month_low, @@pragma[:price_per_sf]))
          score("Core", "Lease Price (High)", 100, *@sample.score_numericality_of(:sf_month_high, @@pragma[:price_per_sf]))
          score("Core", "Space Available", 50, *@sample.score_numericality_of(:space_available, @@pragma[:space_ranges]))
          score("Core", "Min Divisible", 50, *@sample.score_numericality_of(:min_divisible, @@pragma[:space_ranges]))
          score("Core", "Max Contiguous", 50, *@sample.score_numericality_of(:max_contiguous, @@pragma[:space_ranges]))
        end
      end
    end
  end
end