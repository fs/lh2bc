module Basecamp
  class Record #:nodoc:
    attr_reader :type
    
    def initialize(hash)
      # type = self.class.to_s
      @hash = hash
    end

    def [](name)
      name = name.to_s.dasherize

      case @hash[name]
      when Hash then
        puts @hash[name].inspect
        @hash[name] = if (@hash[name].keys.length == 1 && @hash[name].values.first.is_a?(Array))
          @hash[name].values.first.map { |v| self.class.new_with_type(@hash[name].keys.first, v) }
        else
          self.class.new_with_type(name, @hash[name])
        end
      else
        @hash[name]
      end
    end

    def id
      @hash['id']
    end

    def attributes
      @hash.keys
    end

    def respond_to?(sym)
      super || @hash.has_key?(sym.to_s.dasherize)
    end

    def method_missing(sym, *args)
      if args.empty? && !block_given? && respond_to?(sym)
        self[sym]
      else
        super
      end
    end

    def to_s
      "\#<Record(#{self.class}) #{@hash.inspect[1..-2]}>"
    end

    def inspect
      to_s
    end

    # A convenience method for wrapping the result of a query in a Record
    # object. This assumes that the result is a singleton, not a collection.
    def record(path, parameters = {})
      self.class.record(path, parameters)
    end
   
    class << self
      def new_with_type(type, hash)
        "Basecamp::#{type.classify}".constantize.new(hash)
      end
      
      def record(path, parameters = {})
        result = Basecamp::Base.new.request(path, parameters)
        (result && !result.empty?) ? new(result.values.first) : nil
      end

      # A convenience method for wrapping the result of a query in Record
      # objects. This assumes that the result is a collection--any singleton
      # result will be wrapped in an array.
      def records(path, parameters = {})
        result = Basecamp::Base.new.request(path, parameters)
        node_singular = name.demodulize.underscore.dasherize
        node_plural = node_singular.pluralize

        # FIX: rename FileCategory class to AttachmentCategory
        # node_plural = 'attachment-categories' if node_plural == 'file-categories'
      
        result = result[node_plural][node_singular] or return [] 
        result = [result] unless Array === result
        result.map { |row| new(row) }
      end
    end 
  end  
end
