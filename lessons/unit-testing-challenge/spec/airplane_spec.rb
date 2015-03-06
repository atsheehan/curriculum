require 'spec_helper'

describe Airplane do
  let(:airplane) { Airplane.new('cesna','10','150') }

  describe '#land' do
    context 'airplane not started' do
      it 'informs the user they need to start the plane' do
        expect(airplane.takeoff).to eq 'airplane not started, please start'
      end
    end

    context 'airplane started' do
      context 'airplane on the ground already' do
        it 'informs the user the airplane is already on the ground' do
          airplane.start
          expect(airplane.land).to eq 'airplane already on the ground'
        end
      end

      context 'airplane in the air' do
        it 'lands the airplane' do
          airplane.start
          airplane.takeoff
          expect(airplane.land).to eq 'airplane landed'
        end
      end
    end
  end

  describe '#takeoff' do
    context 'airplane not started' do
      it 'informs the user they need to start the plane' do
        expect(airplane.takeoff).to eq 'airplane not started, please start'
      end
    end

    context 'airplane started' do
      it 'launches the airplane' do
        airplane.start
        expect(airplane.takeoff).to eq 'airplane launched'
      end
    end
  end

  describe '#initialization' do
    it 'stores type' do expect(airplane.type).to eq 'cesna' end
    it 'stores wingloading' do expect(airplane.wingloading).to eq '10' end
    it 'stores horsepower' do expect(airplane.horsepower).to eq '150' end
  end

  describe '#start' do
    context 'airplane not started' do
      it 'starts the airplane' do
        expect(airplane.start).to eq 'airplane started'
      end
    end

    context 'airplane already started' do
      it 'starts the airplane' do
        airplane.start
        expect(airplane.start).to eq 'airplane already started'
      end
    end
  end
end
