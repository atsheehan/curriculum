require_relative "../lib/node"

describe Node do
  before(:each) do
    @node2 = Node.new("Adam")
    @node1 = Node.new("Vikram", @node2)
  end

  describe "#info" do
    it "returns a node's info" do
      expect(@node1.info).to eq("Vikram")
      expect(@node2.info).to eq("Adam")
    end
  end

  describe "#next_node" do
    it "returns the node following the current node" do
      expect(@node1.next_node).to eq(@node2)
    end

    it "returns nil if there is no following node" do
      expect(@node2.next_node).to be_nil
    end
  end

end
