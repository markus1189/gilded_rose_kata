def update_quality(items)
  # Yeah, we have to do it this way, because the 'goblin' will one-shot us
  # if we change the 'Item' class at the bottom
  extender = lambda { |i| i.is_a?(Item) && i.extend(Klassifiable) }
  items.map(&extender).map(&:klassify).map(&:update_quality!)
end

# ------------------------------------------------------------------------------

module Klassifiable
  def klassify
    case name
    when /Sulfuras, Hand of Ragnaros/
      klass = Ragnaros
    when /Aged Brie/
      klass = AgedBrie
    when /Backstage pass/
      klass = BackstagePass
    when /Conjured/
      klass = ConjuredItem
    else
      klass = MyItem
    end

    klass.new(self)
  end
end

module Updateable
  def update_quality!
    update_quality
    update_sell_in
  end

  def change_quality(amount)
    @item.tap { |i| i.quality = [0,i.quality+amount,50].sort[1] }
  end

  def update_quality
    change_quality(-1)
    change_quality(-1) if @item.sell_in <= 0
  end

  def update_sell_in
    @item.sell_in -= 1
  end
end

class MyItem
  include Updateable

  def initialize item
    @item = item
  end
end

class AgedBrie < MyItem
  def update_quality
    change_quality(1)
    change_quality(1) if @item.sell_in <= 0
  end
end

class BackstagePass < MyItem
  def update_quality
    if @item.sell_in <= 0
      @item.quality == 0 || @item.quality = 0
    else
      change_quality(1)
      change_quality(1) if @item.sell_in <=  5
      change_quality(1) if @item.sell_in <= 10
    end
  end
end

class Ragnaros < MyItem
  def update_quality; end
  def update_sell_in; end
end

class ConjuredItem < MyItem
  def update_quality
    super
    super
  end
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
