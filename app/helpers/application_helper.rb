module ApplicationHelper
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/png_outputter'

  def deal_rep_attribution_counts(deals)
    reps = deals.pluck(:sales_rep_id, :split_rep_id).flatten.uniq.reject(&:blank?)

    rep_hash = Hash[*reps.map{ |x| [x, {new: 0, used: 0} ] }.flatten]

    deals.where(split_rep_id:nil).group_by(&:sales_rep_id).each do |k , v|

      rep_hash[k] = {
                      new: v.select{|d| d.is_used == false}.count,
                      used: v.select{|d| d.is_used == true}.count
                    }
    end
    deals.where.not(split_rep_id: nil).each do |d|
      rep_hash[d.sales_rep_id][d.is_used? ? :used : :new] += 0.5
      rep_hash[d.split_rep_id][d.is_used? ? :used : :new] += 0.5
    end

    rep_hash = rep_hash.delete_if{|k,v | k.blank?}
    return rep_hash

    #looks like = [{user_id: {new: count, used: count} }, {user_id: {new: count, used: count} }]
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

  def vehicle_usage_type_text_color_class(usage_type)
    case usage_type
      when "is_used", "loaner"
        "text-dark"
      else
        "text-white"
      end
  end

  def html_barcode(string)
    # barcode = Barby::Code128B.new(string)
    # barcode_for_html = Barby::HtmlOutputter.new(barcode)

    # return barcode_for_html

    code = Barby::Code128B.new(string).to_png(margin:3, height: 10)
    image = Base64.encode64(code.to_s).gsub(/\s+/, "")
    return "data:image/png;base64,#{Rack::Utils.escape(image)}"
  end

  def user_permission_list(permission)
    case permission

      when 'admin'
        "All"
      when "sales_manager"
       "Add/Modify Sales Users<br>Delete Vehicles<br>Modify Stock Number<br>Create Service Tickets<br>Create/modify/delete deals".html_safe
      when 'sales_rep'
        "Create vehicles".html_safe
      when "service_user"
        "Complete service tickets<br>Add/modify service users".html_safe
      when "sales_rep"
    end
  end

end