module Mongoid
  module Random

    extend ActiveSupport::Concern

    included do
      field :_randomization_key, type: Array
      before_create :generate_mongoid_random_key

      index({ _randomization_key: "2d" })
    end

    module ClassMethods

      def random(count=1, random_key=rand)
        limit(count).geo_near([random_key, 0])
      end

    end

  protected

    def generate_mongoid_random_key
      self._randomization_key = [rand, 0]
    end

  end
end
