require 'active_support/core_ext/object/blank'

module WithUid
  # @api private
  class UidGenerator
    include Enumerable

    attr_reader :context, :generator

    def initialize(context, ** options, &generator)
      @context = context
      @generator = generator
      @suffix = options[:suffix]
      @prefix = options[:prefix]
    end

    def each
      return enum_for(:each) unless block_given?

      yield uid(prefix)
      loop do
        next_uid = uid(prefix, suffix)
        yield next_uid
      end
    end

    def suffix
      with_default(@suffix) do
        "_#{SecureRandom.hex(3)}"
      end
    end

    def prefix
      with_default(@prefix) do
        ''
      end
    end

    private

    def uid(prefix, suffix = nil)
      [prefix, context.instance_eval(&generator), suffix].join
    end

    def with_default(value)
      if value.respond_to?(:call)
        value.call(context)
      elsif value.nil?
        yield
      else
        value
      end
    end
  end
end
