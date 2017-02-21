require 'spec_helper'

module Accern
  RSpec.describe Alpha do

    it 'accepts query params' do
      a = Alpha.new(token: 'xyz', ticker: 'aapl')
      expect(a.ticker).to eq('aapl')
    end

    it 'creates uri with correct query params' do
      a = Alpha.new(token: 'xyz', ticker: "aapl,fb,amzn,goog")
      a.create_uri
      expect(a.uri.to_s).to include('ticker=aapl%2Cfb%2Camzn%2Cgoog')
    end

    it 'creates correct uri when ticker is nil ' do
      a = Alpha.new(token: 'xyz', ticker: "")
      a.create_uri
      expect(a.uri.to_s).not_to include('ticker')
    end
  end
end
