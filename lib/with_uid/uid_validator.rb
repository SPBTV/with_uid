require 'active_model/validator'

module WithUid
  # Validates uid
  # @example required uid
  #   validates :id, 'with_uid/uid' => true
  #
  # @example optional uid
  #   validates :id, 'with_uid/uid' => { }allow_blank: true }
  #
  class UidValidator < ActiveModel::EachValidator
    REGEX = /\A[0-9a-z\-_\.]+\z/i

    def validate_each(record, attribute, value)
      return if options.fetch(:allow_blank, false) && value.blank?
      return if value =~ REGEX

      record.errors[attribute] << options.fetch(:message, 'invalid format')
    end
  end
end
