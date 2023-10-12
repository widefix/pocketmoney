# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomaticTopupAction, type: :action do
  let(:account) { create(:account, :parent) }

  subject(:action) { described_class.new(from: account, to: account, amount: 10) }

  describe '#perform_implementation' do
    context 'when all attributes are valid' do
      it { expect { action.perform }.to change(Transaction, :count).by(1) }
    end
  end
end
