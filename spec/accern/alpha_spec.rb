require 'spec_helper'

module Accern
  RSpec.describe Alpha do
    it 'accepts query params' do
      a = Alpha.new(token: 'xyz', params: { ticker: 'appl' })
      expect(a.params).to eq(ticker: 'appl')
    end
  end
end
