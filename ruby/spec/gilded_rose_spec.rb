require 'gilded_rose'

describe GildedRose do
  let(:subject) { described_class.new(item)}
  let(:item) { [Item.new("+5 Dexterity Vest", 10, 20)] }

  describe "#update_quality" do
    it 'does not change the name of the item' do
      expect { subject.update_quality() }.to_not change { item[0].name }
    end

    it 'reduces the number of days in which to sell by 1 each day' do
      expect { subject.update_quality() }.to change { item[0].sell_in }.by(-1)
    end

    it 'does not reduce the quality below 0' do
      15.times { subject.update_quality() }
      expect { subject.update_quality() }.to_not change { item[0].quality }
    end

    describe 'Common items' do
      it 'reduce in quality by 1 each day' do
        expect { subject.update_quality() }.to change { item[0].quality }.by(-1)
      end

      it 'reduce quality by 2 after sell in is 0' do
        10.times { subject.update_quality() }
        expect { subject.update_quality() }.to change { item[0].quality }.by(-2)
      end
    end

    describe 'Aged Brie' do
      let(:item) { [Item.new("Aged Brie", 2, 0)]}

      it 'increases in quality it gets older' do
        expect{ subject.update_quality() }.to change { item[0].quality }.by(1)
      end
      it 'never has a quality higher than 50' do
        50.times {subject.update_quality }
        expect{ subject.update_quality() }.to_not change { item[0].quality }
      end
    end

    describe 'Sulfuras' do
      let(:item) { [Item.new("Sulfuras, Hand of Ragnaros", 1, 80)] }

      it 'does not need to be sold' do
        expect{ subject.update_quality() }.to_not change { item[0].sell_in }
      end

      it 'does not decrease in quality' do
        expect{ subject.update_quality() }.to_not change { item[0].quality }
      end
    end

    describe 'Backstage Passes' do
      let(:item) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)] }

      it 'quality increases as the concert approaches' do
        expect{ subject.update_quality() }.to change { item[0].quality }.by(1)
      end

      it 'quality increases twice as fast when there are 10 days or less to go' do
        item[0].sell_in = 10
        expect{ subject.update_quality() }.to change { item[0].quality }.by(2)
      end

      it 'quality increases three times as fast when there are 5 days or less to go' do
        item[0].sell_in = 5
        expect{ subject.update_quality() }.to change { item[0].quality }.by(3)
      end

      it 'does not increase in quality past 50' do
        item[0].sell_in = 5
        item[0].quality = 50
        expect{ subject.update_quality() }.to_not change { item[0].quality }
      end
      it 'quality drops to 0 after the concert' do
        item[0].sell_in = 0
        expect{ subject.update_quality() }.to change { item[0].quality }.by(-item[0].quality)
      end
    end

    describe 'Conjured items' do
      let(:item) { [Item.new(name="Conjured Mana Cake", sell_in=3, quality=6)] }

      it 'degrade in quality twice as fast' do
        expect { subject.update_quality() }.to change { item[0].quality }.by(-2)
      end
    end
  end
end
