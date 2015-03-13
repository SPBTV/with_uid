require 'spec_helper'
require 'support/model_with_uid'

RSpec.describe WithUid do
  describe '.format' do
    it do
      formatted = WithUid.format('[The] unFormaTTEd, — String! & punctuations')
      expect(formatted).to eq('the-unformatted-string-punctuations')
    end
  end

  context 'generation' do
    specify 'without block' do
      model = ModelWithUid.new(name: 'b37')
      expect do
        model.valid?
      end.to change {
        model.uid
      }.from(nil)
    end

    it 'success' do
      model = ModelWithUid.new(name: 'b37')

      model.generate_uid do
        "#{name}-42"
      end

      expect(model.uid).to eq 'b37-42'
    end

    it 'set uid manual' do
      model = ModelWithUid.new(uid: 'bbc', name: 'BBC')

      model.generate_uid do
        "#{name}-42"
      end

      expect(model.uid).to eq('bbc')
    end

    it 'run callbacks' do
      model = ModelWithUid.new(uid: 'bbc', name: 'BBC')

      expect(model).to receive(:generate_uid)

      model.valid?
    end
  end
end
