
class CashRegister
  def input
    input_number = 1
    puts "input #{input_number}:"
    order = gets("\t\n").chomp
    invoice(order.strip)
  end

  def invoice(order)
    apply_taxes = verify_taxes(order)
    order_lines = order.split("\n")
    order_breakdown = order_breakdown(order_lines)
    taxes = taxes(order_breakdown, apply_taxes)
    subtotal = subtotal(order_breakdown)
    items = items(order_breakdown)
    output(items, taxes, subtotal)
  end

  def order_breakdown(order_lines)
    order_lines.map{|current_line| current_line.split(" ") }
  end

  def subtotal(order_breakdown)
    order_breakdown.map{|line| line.first.to_i * line.last.to_f }
  end

  def taxes(order_breakdown, apply_taxes)
    order_breakdown.map.with_index{ |value, index| (value.first.to_i * value.last.to_f * apply_taxes[index]).round(2) }
  end

  def items(order_breakdown)
    order_breakdown.map{|line| (line.shift(3)).join(" ")  }
  end

  def output(items, taxes, subtotal)
    output = "Output 1:\n"
    details = items.map.with_index{|value, index|  value.concat( (subtotal[index] * taxes[index]).to_s) }.join("\n")
    output.concat(details)
    output.concat("\nSales Taxes: #{sprintf("%.2f",taxes.sum)} \nTotal: #{sprintf("%.2f",(subtotal.sum + taxes.sum))}")
    puts(output)
  end

  def verify_taxes(order_lines)
    products = ['imported', 'perfume', 'CD']
    values = order_lines.split("\n").map do |lines|
      if lines =~ /imported/ && (lines =~ /perfume/ || lines =~ /CD/)
         0.15
      elsif lines =~ /imported/
        0.05
      elsif lines =~ /perfume/ || lines =~ /CD/
        0.10
      elsif lines =~ /imported/ && (lines =~ /perfume/ || lines =~ /CD/)
        0.15
      else
        0
      end
    end
    values
  end
end

cash_register = CashRegister.new
cash_register.input
