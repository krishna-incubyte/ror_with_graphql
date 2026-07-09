require 'rails_helper'

RSpec.describe CurrencyExchangeRateFetcher, type: :service do
  describe '.execute' do
    it 'fetches the currency conversion rate between INR and USD' do
      VCR.use_cassette 'services/currency_rate_fetcher/success' do
        conversion_rate = described_class.execute(source: 'INR', target: 'USD')

        expect(conversion_rate).to eq(0.01046)
      end
    end

    context 'when invalid keys' do
      it 'returns invalid-key error message' do
        allow(Rails.application.credentials.exchange_rate).to receive(:api_key).and_return("17892749893993a72837")

        VCR.use_cassette 'services/currency_rate_fetcher/error' do
          response = described_class.execute(source: 'INR', target: 'USD')

          expect(response).to eq('invalid-key')
        end
      end
    end
  end
end