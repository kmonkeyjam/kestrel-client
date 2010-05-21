require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Kestrel::Client::Namespace do
  describe "Instance Methods" do
    before do
      @raw_kestrel_client = Kestrel::Client.new(*Kestrel::Config.default)
    end

    describe "Has Namespace" do
      before do
        @kestrel = Kestrel::Client::Namespace.new('some_namespace', @raw_kestrel_client)
      end

      it "prepends a namespace to the key" do
        mock(@raw_kestrel_client).set('some_namespace:a_queue', :mcguffin)
        @kestrel.set('a_queue', :mcguffin)
      end

      it "available_queues only returns namespaced queues" do
        @raw_kestrel_client.set('some_namespace:namespaced_queue', 'foo')
        @raw_kestrel_client.set('unnamespaced_queue', 'foo')

        @kestrel.available_queues.should == ['namespaced_queue']
      end
    end

    describe "Empty Namespace" do
      before do
        @kestrel = Kestrel::Client::Namespace.new('', @raw_kestrel_client)
      end

      it "not prepend a namespace to the key" do
        mock(@raw_kestrel_client).get('a_queue')
        @kestrel.get('a_queue')
      end

      it "returns all queues" do
        @raw_kestrel_client.set('some_namespace:namespaced_queue', 'foo')
        @raw_kestrel_client.set('unnamespaced_queue', 'foo')
        @kestrel.available_queues.should == ['some_namespace:namespaced_queue', 'unnamespaced_queue']
      end
    end

  end
end
