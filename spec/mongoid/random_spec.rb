require 'spec_helper'

describe Mongoid::Random do

  describe "#generate_mongoid_random_key" do

    subject { Randomized.new }

    it "initially start with a nil key" do
      expect(subject._randomization_key).to be_nil
    end

    it "should generate a coordinate key with first part between 0 and 1" do
      subject.save!
      expect(subject._randomization_key[0]).to be_between(0, 1)
    end

    it "should generate a coordinate key with second part equal to 0" do
      subject.save!
      expect(subject._randomization_key[1]).to eq 0
    end

  end


  describe ".random" do

    let!(:doc1) { Randomized.create }

    it "always pull @doc1 in random query" do
      4.times do
        expect(Randomized.random.first) == doc1
      end
    end

    context "when there are 2 possible records" do

      let!(:doc2) { Randomized.create }

      it "has 2 records to choose from" do
        expect(Randomized.count).to eq 2
      end

      it "only retrieves 1 record for :random" do
        3.times do
          expect(Randomized.random.to_a.size).to eq 1
        end
      end

      it "retrieves for :random of 2" do
        expect(Randomized.random(2).to_a.size).to eq 2
      end

      it "have both outcomes from random 2 queries" do
        outcomes = 100.times.inject(Array.new) { |a, i| a << Randomized.random(2).to_a; a }
        expect(outcomes.uniq.sort).to eq([ [ doc1, doc2 ], [ doc2, doc1 ] ].sort)
      end

    end

  end

end
