class GildedRose
  SPECIAL_ITEMS = [
    'Aged Brie',
    'Sulfuras, Hand of Ragnaros',
    'Backstage passes to a TAFKAL80ETC concert',
    'Conjured Mana Cake'
  ]
  MAX_ITEM_QUALITY = 50
  STANDARD_CHANGE = 1
  QUICKER_CHANGE = STANDARD_CHANGE * 2
  EXPIRED_CONJURED_CHANGE = QUICKER_CHANGE * 2
  FIRST_CONCERT_INCREASEgit 
  SECOND_CONCERT_INCREASE

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      item.sell_in -= STANDARD_CHANGE if item.name != 'Sulfuras, Hand of Ragnaros'
      update_common(item) if common_item?(item.name)
      update_conjured(item) if item.name.include?('Conjured')
      update_brie(item) if item.name == 'Aged Brie'
      update_passes(item) if item.name == 'Backstage passes to a TAFKAL80ETC concert'
    end
  end

  private

  def common_item?(item)
    !SPECIAL_ITEMS.include?(item) ? true : false
  end

  def update_common(item)
    item.quality -= item.sell_in.positive? ? STANDARD_CHANGE : QUICKER_CHANGE unless item.quality.negative?
  end

  def update_conjured(item)
    item.quality -= item.sell_in.positive? ? QUICKER_CHANGE : EXPIRED_CONJURED_CHANGE unless item.quality.negative?
  end

  def update_brie(item)
    item.quality += STANDARD_CHANGE if item.quality < MAX_ITEM_QUALITY
  end

  def update_passes(item)
    item.sell_in.positive? ? concert_markup(item) : item.quality -= item.quality
  end

  def concert_markup(item)
    item.quality += STANDARD_CHANGE if item.quality < MAX_ITEM_QUALITY
    item.quality += STANDARD_CHANGE if item.sell_in < 11 && item.quality < MAX_ITEM_QUALITY
    item.quality += STANDARD_CHANGE if item.sell_in < 6 && item.quality < MAX_ITEM_QUALITY
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
