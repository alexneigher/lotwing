module ApplicationHelper

  def deal_rep_attribution_counts(deals)
    reps = deals.pluck(:sales_rep, :split_rep).flatten.uniq.reject(&:blank?)
    
    rep_hash = Hash[*reps.map{ |x| [x, {new: 0, used: 0} ] }.flatten]

    deals.where(split_rep:'').group_by(&:sales_rep).each do |k , v| 

      rep_hash[k] = {
                      new: v.select{|d| d.is_used == false}.count, 
                      used: v.select{|d| d.is_used == true}.count
                    }
    end

    deals.where.not(split_rep:'').each do |d|
      rep_hash[d.sales_rep][d.is_used? ? :used : :new] += 0.5
      rep_hash[d.split_rep][d.is_used? ? :used : :new] += 0.5
    end

    rep_hash = rep_hash.delete_if{|k,v | k.blank?}
    
    return rep_hash

    #looks like = [{name: {new: count, used: count} }, {name: {new: count, used: count} }]
  end

  def vehicle_usage_type_bg_color(usage_type)

    case usage_type 
      when "is_used"
        "#66CC00"
      when "is_new"
        "#006699"
      when "loaner"
        "#E8F051"
      when "lease_return"
        "#D13CEA"
      when "wholesale_unit"
        "#8D8C88"
      end
  end
  
end