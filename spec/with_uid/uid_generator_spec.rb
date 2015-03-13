require 'spec_helper'
require 'with_uid/uid_generator'
require 'ostruct'

RSpec.describe WithUid::UidGenerator do
  let(:name) { 'The name' }
  let(:suffix) { '_suffix' }
  let(:prefix) { 'prefix_' }
  let(:binding) do
    OpenStruct.new(name: name)
  end

  def generator(**options)
    WithUid::UidGenerator.new(binding, **options) do
      "#{name}-42"
    end
  end

  context 'yielding' do
    it 'yield uids' do
      uids = generator(prefix: prefix, suffix: suffix).each
      uid_from_block = uids.next
      uid_with_suffix = uids.next

      expect(uid_from_block).to eq "#{prefix}#{name}-42"
      expect(uid_with_suffix).to eq "#{prefix}#{name}-42#{suffix}"
    end

    it 'yield uids without prefix' do
      uids = generator(suffix: suffix).each
      uid_from_block = uids.next
      uid_with_suffix = uids.next

      expect(uid_from_block).to eq "#{name}-42"
      expect(uid_with_suffix).to eq "#{name}-42#{suffix}"
    end

    it 'with empty suffix' do
      uids = generator(suffix: '').each
      uid_from_block = uids.next
      uid_with_suffix = uids.next

      expect(uid_from_block).to eq "#{name}-42"
      expect(uid_with_suffix).to eq "#{name}-42"
    end
  end

  describe '#suffix' do
    it 'default value is nil' do
      suffix = generator.suffix

      expect(suffix.size).to eq(7)
    end

    it 'default value is callable' do
      suffix_generator = ->(context) { "#{context.name}:foo_bar" }
      suffix = generator(suffix: suffix_generator).suffix

      expect(suffix).to eq 'The name:foo_bar'
    end

    it 'default value' do
      suffix = generator(suffix: '32').suffix

      expect(suffix).to eq '32'
    end
  end

  describe '#prefix' do
    it 'default value is nil' do
      prefix = generator.prefix

      expect(prefix).to eq('')
    end

    it 'default value is callable' do
      prefix_generator = ->(context) { "#{context.name}:foo_bar" }
      prefix = generator(prefix: prefix_generator).prefix

      expect(prefix).to eq 'The name:foo_bar'
    end

    it 'default value' do
      prefix = generator(prefix: '32').prefix

      expect(prefix).to eq '32'
    end
  end
end
