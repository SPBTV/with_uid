require 'spec_helper'
require 'ostruct'
require 'with_uid'
require 'active_model'

RSpec.describe WithUid::UidValidator do
  ModelWithRequiredUid = Struct.new(:uid) do
    include ActiveModel::Model
    include ActiveModel::Validations

    validates :uid, 'with_uid/uid' => true
  end

  ModelWithOptionalUid = Struct.new(:uid) do
    include ActiveModel::Validations

    validates :uid, 'with_uid/uid' => { allow_blank: true }
  end

  context 'model with required uid' do
    subject(:model) { ModelWithRequiredUid.new }

    it 'is invalid if uid is empty string' do
      model.uid = ''

      expect(model).to be_invalid
    end

    it 'is invalid if uid is nil' do
      model.uid = nil

      expect(model).to be_invalid
    end

    it 'is valid if uid is present' do
      model.uid = '123'

      expect(model).to be_valid
    end

    it 'is invalid if uid is present and contains forbidden chars' do
      model.uid = ':/.123'

      expect(model).to be_invalid
    end
  end

  context 'model with optional uid' do
    subject(:model) { ModelWithOptionalUid.new }

    it 'is valid if uid is empty string' do
      model.uid = ''

      expect(model).to be_valid
    end

    it 'is valid if uid is nil' do
      model.uid = nil

      expect(model).to be_valid
    end

    it 'is valid if uid is present' do
      model.uid = '123'

      expect(model).to be_valid
    end

    it 'is invalid if uid is present and contains forbidden chars' do
      model.uid = ':/.123'

      expect(model).to be_invalid
    end
  end
end
