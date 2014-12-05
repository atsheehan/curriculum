require_relative '../lib/bounding_box'

describe BoundingBox do
  let(:box) { BoundingBox.new(5.0, 10.0, 25.0, 50.0) }

  it 'has a left edge' do
    expect(box.left).to eq(5.0)
  end

  it 'has a right edge' do
    expect(box.right).to eq(30.0)
  end

  it 'has a bottom edge' do
    expect(box.bottom).to eq(10.0)
  end

  it 'has a top edge' do
    expect(box.top).to eq(60.0)
  end

  it 'has a width' do
    expect(box.width).to eq(25.0)
  end

  it 'has a height' do
    expect(box.height).to eq(50.0)
  end

  describe '#contains_point?' do
    it 'is true for points within the box' do
      expect(box.contains_point?(20.0, 20.0)).to eq(true)
    end

    it 'is true for points on the edge of the box' do
      expect(box.contains_point?(5.0, 10.0)).to eq(true)
      expect(box.contains_point?(30.0, 60.0)).to eq(true)
    end

    it 'is false for points outside of the box' do
      expect(box.contains_point?(0.0, 0.0)).to eq(false)
      expect(box.contains_point?(20.0, 100.0)).to eq(false)
      expect(box.contains_point?(50.0, 20.0)).to eq(false)
    end
  end
end
