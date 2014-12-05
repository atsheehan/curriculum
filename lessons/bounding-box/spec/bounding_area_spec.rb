require_relative '../lib/bounding_area'

describe BoundingArea do
  describe '#contains_point?' do

    it 'is always false for an empty bounding area' do
      empty_area = BoundingArea.new([])
      expect(empty_area.contains_point?(0.0, 0.0)).to eq(false)
    end

    it 'is true if the point is contained within one of the rects' do
      bottom_rect = BoundingBox.new(0.0, 0.0, 2.0, 1.0)
      top_rect = BoundingBox.new(2.0, 1.0, 3.0, 4.0)

      area = BoundingArea.new([bottom_rect, top_rect])

      expect(area.contains_point?(0.5, 0.5)).to eq(true)
      expect(area.contains_point?(0.5, 0.5)).to eq(true)
      expect(area.contains_point?(0.5, 0.5)).to eq(true)
    end

    it 'is false if the point is outside of all of the rects' do
      bottom_rect = BoundingBox.new(0.0, 0.0, 2.0, 1.0)
      top_rect = BoundingBox.new(2.0, 1.0, 3.0, 4.0)

      area = BoundingArea.new([bottom_rect, top_rect])

      expect(area.contains_point?(0.0, 3.0)).to eq(false)
      expect(area.contains_point?(6.0, 4.0)).to eq(false)
    end
  end
end
