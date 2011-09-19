=begin
  Listing Evaluator

  make a long version first,
  then shorten it.

=end


module PL
  module Aristotle
    module Analyst
      class Listing < PL::Aristotle::Core
        
        def process
          # core information
          score("Core", "Last Updated Date", 50, *@sample.score_recency_of_update)
          score("Core", "County Information", 10, *@sample.score_presence_of(:county)) if @sample.usa?
          score("Core", "Postcode Information", 10, *@sample.score_format_of(:postcode, @@pragma[:formats][:postcode])) if @sample.usa?
          score("Core", "Category", 20, *@sample.score_format_of(:category, @@pragma[:formats][:category]))
          score("Core", "Zoning", 10, *@sample.score_presence_of(:zoning))
          score("Core", "Parcel", 25, *@sample.score_presence_of(:parcel))
          score("Core", "Data Validity", 50, *@sample.score_format_of(:source, @@pragma[:formats][:source]))
          
          # sizes
          score("Price And Area", "Building Size", 10, *@sample.score_numericality_of(:building_sf, @@pragma[:ranges][:building]))
          score("Price And Area", "Building Stories", 10, *@sample.score_numericality_of(:building_stories, @@pragma[:ranges][:stories]))
          score("Price And Area", "Lot Size", 10, *@sample.score_numericality_of(:lot_sf, @@pragma[:ranges][:lot]))
          score("Price And Area", "Office Size", 5, *@sample.score_presence_of(:office_sf))
          score("Price And Area", "Lot Depth", 5, *@sample.score_numericality_of(:lot_depth_feet, @@pragma[:ranges][:lot_feet]))
          score("Price And Area", "Lot Frontage", 5, *@sample.score_numericality_of(:lot_frontage_feet, @@pragma[:ranges][:lot_feet]))
          score("Price And Area", "Coop Commission", 20, *@sample.score_numericality_of(:coop_commission, @@pragma[:ranges][:coop_commission]))
          
          # sale price
          if (@sample.sale)
            corrupt(@sample.sale)
            score("Price And Area", "Price Per Building SF", 25, *score_divide(@sample.sale.price, @sample.building_sf.to_i, @@pragma[:price_ranges][:building_sf]))
            score("Price And Area", "Total Price", 25, *@sample.sale.score_numericality_of(:price, @@pragma[:price_ranges][:total_price]))
            
            # auction
            if (@sample.sale.auction)
              corrupt(@sample.sale.auction)
              score("Price And Area", "Inspection Date", 25, *@sample.sale.auction.score_presence_of(:inspected_at))
              score("Price And Area", "Auction Deposit", 25, *@sample.sale.auction.score_numericality_of(:deposit, @@pragma[:price_ranges][:auction_generics]))
              score("Price And Area", "Auction Premium", 25, *@sample.sale.auction.score_numericality_of(:premium, @@pragma[:price_ranges][:auction_generics]))
            end
            
            # cash flow
            if (@sample.sale.cash_flow)
              corrupt(@sample.sale.cash_flow)
              score("Cash Flow", "Proforma", 5, *@sample.sale.cash_flow.score_presence_of(:proforma))
              score("Cash Flow", "Loan Existing", 5, *@sample.sale.cash_flow.score_presence_of(:loan_existing))
              score("Cash Flow", "Amortized Over", 5, *@sample.sale.cash_flow.score_presence_of(:amortized_over))
              score("Cash Flow", "Cap Rate", 5, *@sample.sale.cash_flow.score_presence_of(:cap_rate))
              score("Cash Flow", "Cash On Cash", 5, *@sample.sale.cash_flow.score_presence_of(:cash_on_cash))
              score("Cash Flow", "Effective Gross", 5, *@sample.sale.cash_flow.score_presence_of(:effective_gross))
              score("Cash Flow", "Gross Rent Multiplier", 5, *@sample.sale.cash_flow.score_presence_of(:gross_rent_multiplier))
              score("Cash Flow", "Insurance", 5, *@sample.sale.cash_flow.score_presence_of(:insurance))
              score("Cash Flow", "Maintenance", 5, *@sample.sale.cash_flow.score_presence_of(:maintenance))
              score("Cash Flow", "Net Operating Income", 5, *@sample.sale.cash_flow.score_presence_of(:net_operating_income))
              score("Cash Flow", "Operating Expense", 5, *@sample.sale.cash_flow.score_presence_of(:operating_expense))
              score("Cash Flow", "Other Expenses", 5, *@sample.sale.cash_flow.score_presence_of(:other_expenses))
              score("Cash Flow", "Other Income", 5, *@sample.sale.cash_flow.score_presence_of(:other_income))
              score("Cash Flow", "Pretax Cash Flow", 5, *@sample.sale.cash_flow.score_presence_of(:pretax_cash_flow))
              score("Cash Flow", "Real Estate Taxes", 5, *@sample.sale.cash_flow.score_presence_of(:real_estate_taxes))
              score("Cash Flow", "Taxes", 5, *@sample.sale.cash_flow.score_presence_of(:taxes))
              score("Cash Flow", "Total Expenses", 5, *@sample.sale.cash_flow.score_presence_of(:total_expenses))
              score("Cash Flow", "Debt Service", 5, *@sample.sale.cash_flow.score_presence_of(:debt_service))
              score("Cash Flow", "Down Payment", 5, *@sample.sale.cash_flow.score_presence_of(:down_payment))
              score("Cash Flow", "Due", 5, *@sample.sale.cash_flow.score_presence_of(:due))
              score("Cash Flow", "Vacancy", 5, *@sample.sale.cash_flow.score_presence_of(:vacancy))
              score("Cash Flow", "Reimbursement", 5, *@sample.sale.cash_flow.score_presence_of(:reimbursement))
              score("Cash Flow", "Income Item", 5, *@sample.sale.cash_flow.score_presence_of(:income_item))
              score("Cash Flow", "Other Capital Costs", 5, *@sample.sale.cash_flow.score_presence_of(:other_capital_costs))
              score("Cash Flow", "Principal", 5, *@sample.sale.cash_flow.score_presence_of(:principal))
              score("Cash Flow", "HVAC", 5, *@sample.sale.cash_flow.score_presence_of(:hvac))
              score("Cash Flow", "Interest Rate", 5, *@sample.sale.cash_flow.score_presence_of(:interest_rate))
              score("Cash Flow", "Loan Description", 5, *@sample.sale.cash_flow.score_presence_of(:loan_description))
            else
              score("Cash Flow", "Presence", 20, 0.0, "Cash Flow Information Not Entered.")
            end
          end
          
          # lease scoring
          # i don't know how to do lease scoring, right now we will just average space price scores, later we can average actual scores.
          if @sample.lease?
            if @sample.spaces.size > 0
              _ = @sample.spaces.first(:select => '(SUM(quality) / COUNT(id)) AS average_score', :group => 'listing_id ASC')
              price_avg = _ ? _.average_score.to_f : 0.0
            else
              price_avg = 0.0
            end
            score("Lease Spaces", "Scores", 50, price_avg, "Combined lease scores.")
          end
          
          
          # data completeness
          score("Data Completeness", "Anchors", 15, *@sample.score_combined_presence_of(:anchor1, :anchor2, :anchor3))
          score("Data Completeness", "Building Free Standing Status", 10, *@sample.score_presence_of(:building_free_standing))
          score("Data Completeness", "Build Year", 10, *@sample.score_numericality_of(:year_built, @@pragma[:ranges][:na_year_built])) if @sample.usa?
          score("Data Completeness", "Building Condition", 10, *@sample.score_presence_of(:building_condition))
          score("Data Completeness", "Clearance Height", 10, *@sample.score_numericality_of(:clearance_height, @@pragma[:ranges][:clearance_height]))
          score("Data Completeness", "Cross Streets", 10, *@sample.score_combined_presence_of(:cross_street1, :cross_street_type1, :cross_street2, :cross_street_type2))
          score("Data Completeness", "Loading Docks", 10, *@sample.score_numericality_of(:docks_loading, @@pragma[:ranges][:docks]))
          score("Data Completeness", "Dock High Doors", 10, *@sample.score_numericality_of(:doors_dock_high, @@pragma[:ranges][:docks]))
          score("Data Completeness", "Drive In Doors", 10, *@sample.score_numericality_of(:doors_drive_in, @@pragma[:ranges][:docks]))
          score("Data Completeness", "Facilities", 30, *@sample.score_combined_presence_of(:facilities_cooling, :facilities_cranes, :facilities_heating, :facilities_kitchen, :facilities_lighting, :facilities_power, :facilities_rail, :facilities_sprinkler))
          score("Data Completeness", "Occupied Percentage", 10, *@sample.score_numericality_of(:occupied_percentage, @@pragma[:ranges][:percentage]))
          score("Data Completeness", "Parking Ratio", 10, *@sample.score_numericality_of(:parking_ratio, @@pragma[:ranges][:parking_ratio]))
          score("Data Completeness", "Parking Covered Ratio", 5, *@sample.score_numericality_of(:parking_covered_ratio, @@pragma[:ranges][:covered_ratio]))
          score("Data Completeness", "Vacancy", 10, *@sample.score_presence_of(:vacancy))
          score("Data Completeness", "Multitenant", 5, *@sample.score_presence_of(:multitenant))
          score("Data Completeness", 'Use Type', 5, *@sample.score_presence_of(:use_type))
          score("Data Completeness", 'Traffic Count', 5, *@sample.score_presence_of(:traffic_count))
          
          # images
          score("Image","Default Image Present", 10, *@sample.score_presence_of(:default_image_id))
        end   
        



        @@pragma = {
          :formats => {
            :category => [[90.0, /SPEC/, "Default Category selected."], [100.0, /.*/, "Category selected."]],
            :postcode => [[100.0, /\d{5}\-\d{4}/, "Valid 9-digit USA postcode."], [90.0, /\d{5}/, "Valid 5-digit USA postcode."]],
            :source => [[100.0, /^pl$/, "Validated By Property Line."], [80.0, /pld/, "Not yet checked for quality."], [80.0, /bulk/, "Entered via bulk."]]
          },
          :price_ranges => {
            :building_sf => [
              [10.0, (0.01)..(2.0), "Price per square foot is low."],
              [100.0, (2.01)..(300.0), "Price per square foot is in acceptable range."],
              [10.0, 300.01, "Price per square foot is high."]
            ],
            :total_price => [
              [10.0, (0.01)..(30000.0), "Sale Price is low."],
              [100.0, 30000..20000000, "Sale price is acceptable."],
              [10.0, 20000001, "Sale price is high."]
            ],

            :auction_generics => [
              [10.0, (0.01)..(100.0), "Auction deposit is low."],
              [100.0, 100, "Auction deposit is acceptable."]
            ]
              
          
          },
          :ranges => {
            :building => [
              [10.0, 1..500, "Building SF is extremely low."],
              [10.0, 348000, "Building SF is higher than NASA Vehicle Assembly Building."],
              [100.0, 500..348000, "Building square footage is acceptable."]
            ],
            :clearance_height => [
              [0.0, 1..42, "Clearance height is extremely low."],
              [100.0, 43..120, "Clearance height is acceptable."],
              [80.0, 121..300, "Clearance height is very high."],
              [30.0, 301, "Clearance height is extremely high."]
            ],
            :coop_commission => [
              [0.0, 0..1, "Co-op Commission is low."],
              [100.0, 1, "Co-op commission is in acceptable range."]
            ],
            :docks => [
              [100.0, 0..8, "Dock count is acceptable."],
              [75.0, 9..36, "Dock count is high."],
              [0.0, 37, "Dock count is extremely high."]
            ],
            :lot => [
              [10.0, 1..500, "Lot Size is very low."],
              [90.0, 435600, "Lot Size is very large."],
              [100.0, 500..435600, "Lot size is acceptable."]
            ],
            :lot_feet => [
              [100.0, 1..330, "Length is acceptable."],
              [40.0, 331, "Length is very high."]
            ],
            :stories => [
              [100.0, 1..100, "Building has an acceptable number of stories."],
              [45.0, 101, "Building has an extremely large number of stories."]
            ],
            :na_year_built => [
              [0.0, 1..1491, "Building built before the discovery of America."],
              [100.0, 1492..(Time.now.year), "Building year is acceptable."],
              [0.0, Time.now.year, "Build year is set in the future."]
            ],
            :covered_ratio => [
              [100.0, 0..4, "Parking ratio is acceptable."],
              [30.0, 4, "Parking ratio is high."]
            ],
            :parking_ratio => [
              [60.0, (0.0)..(0.49), "Parking ratio is low."],
              [100.0, (0.5)..(6.0), "Parking ratio is acceptable."],
              [30.0, 6.01, "Parking ratio is high."]
            ],
            :percentage => [
              [100.0, 0..100, "Acceptable percentage."]
            ]
          }
        }

      end
    end
  end
end