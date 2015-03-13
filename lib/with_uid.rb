require 'active_support/concern'
require 'securerandom'
require 'with_uid/version'
require 'with_uid/uid_generator'
require 'with_uid/uid_validator'

# Allow to generate nice uids for ActiveRecord objects
#
module WithUid
  extend ActiveSupport::Concern

  included do
    validates :uid, presence: true
    validates :uid, uniqueness: true, unless: :skip_uid_uniqueness?
    validates :uid, :'with_uid/uid' => true
  end

  module ClassMethods
    # Find record by uid
    #
    # @param uid [String]
    # @return [ActiveRecord::Base]
    # @raise [ActiveRecord::RecordNotFound] if no such record
    # @see #find_by!
    #
    def by_uid!(uid)
      find_by!(uid: uid)
    end

    # Find record by uid
    #
    # @param uid [String]
    # @return [ActiveRecord::Base, nil]
    # @see #find_by
    #
    def by_uid(uid)
      find_by(uid: uid)
    end

    # Generate uid for given model
    #
    # @yieldreturn [String] generated uid. So you may specify the
    #   way of generating uid.
    # @param [Hash]
    # @option options [String, Proc] :prefix ('') prefix for uid
    #   inserted for each generated uid.
    # @option options [String, Proc] :suffix (random string) for uid
    #   inserted if uid is not uniq.
    # @return [void]
    #
    # @example without block
    #   class User < ActiveRecord::Base
    #     generate_uid(prefix: ->(user) { user.sex })
    #   end
    #
    # @example with block using user's name
    #   class User < ActiveRecord::Base
    #     generate_uid(prefix: 'user_') do
    #       WithUid.format(name)
    #     end
    #   end
    #
    # If no block given it will generate uid according RFC 4122.
    # You are free to customize this uid with +:prefix+.
    #
    # @example RFC 4122 uid
    #   class User < ActiveRecord::Base
    #     generate_uid
    #   end
    #
    def generate_uid(**options, &block)
      before_validation do
        if block_given?
          generate_uid(**options, &block)
        else
          generate_uid(**options) do
            SecureRandom.uuid
          end
        end
      end
    end

    # Generate uid using record's attribute
    #
    # @param attr [Symbol] attribute name
    # @param options [Hash] @see #generate_uid
    # @return [void]
    #
    # @example
    #   class User < ActiveRecord::Base
    #     humanize_uid_with(:name, prefix: 'user_')
    #   end
    #   user = User.create(name: 'Tema Bolshakov')
    #   user.uid #=> "tema_bolshakov"
    #
    def humanize_uid_with(attr, **options)
      generate_uid(**options) do
        value = send(attr)
        WithUid.format(value) if value.present?
      end
    end
  end

  # If you are not interested in uid uniqeness
  # redefine this method in your model
  # @example
  #   class User < ActiveRecord::Base
  #     humanize_uid_with(:name, prefix: 'user_')
  #
  #     def skip_uid_uniqueness?
  #       true
  #     end
  #   end
  #
  def skip_uid_uniqueness?
    false
  end

  def self.format(str)
    I18n.transliterate(str.to_s).parameterize
  end

  # @api private
  def generate_uid(**options, &block)
    fail LocalJumpError, 'no block given' unless block_given?
    return if uid.present?

    self.uid = uid_generator(**options, &block).detect do |uid|
      !self.class.exists?(uid: uid)
    end
  end

  # @api private
  def uid_generator(**options, &block)
    UidGenerator.new(self, **options, &block)
  end
end
