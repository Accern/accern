require 'spec_helper'

module Accern
  RSpec.describe Alpha do

    it 'accepts query params' do
      a = Alpha.new(token: 'xyz', ticker: 'aapl', index: 'wilshire5000')
      expect(a.ticker).to eq('aapl')
      expect(a.index).to eq('wilshire5000')
    end

    it 'creates uri with correct query params' do
      a = Alpha.new(token: 'xyz', ticker: "aapl,fb,amzn,goog", index: "wilshire5000")
      a.create_uri
      expect(a.uri.to_s).to include('ticker=aapl%2Cfb%2Camzn%2Cgoog', 'index=wilshire5000')
    end

    it 'creates correct uri when filters are nil ' do
      a = Alpha.new(token: 'xyz', ticker: "", index: '')
      a.create_uri
      expect(a.uri.to_s).not_to include('ticker', 'index')

    end
  end
end
