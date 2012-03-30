def update_quality(items)
  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.name != 'Sulfuras, Hand of Ragnaros'
        change_quality(item, -1)
      end
    else
      change_quality(item, 1)
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        if item.sell_in < 11
          change_quality(item, 1)
        end
        if item.sell_in < 6
          change_quality(item, 1)
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.name != 'Sulfuras, Hand of Ragnaros'
            change_quality(item, -1)
          end
        else
          item.quality = 0
        end
      else
        change_quality(item, 1)
      end
    end
  end
end

def change_quality(item, amount)
  new_quality = [0, item.quality + amount].max
  new_quality = [new_quality, 50].min
  item.quality = new_quality
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

