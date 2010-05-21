module Kestrel
  class Client
    class Namespace < Proxy
      def initialize(namespace, client)
        @namespace = namespace
        @matcher = /\A#{Regexp.escape(@namespace)}:(.+)/
        super(client)
      end

      def method_missing(method, key, *args)
        client.send(method, namespace(key), *args)
      end

      def available_queues
        client.available_queues.map {|q| in_namespace(q) }.compact
      end

      def in_namespace(key)
        if @namespace.nil? || @namespace.empty?
          return key
        elsif match = @matcher.match(key)
          match[1]
        end
      end

      private

      def namespace(key)
        if @namespace.nil? || @namespace.empty?
          key
        else
          "#{@namespace}:#{key}"
        end
      end
    end
  end
end
