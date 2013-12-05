class Node
  attr_accessor :data
  attr_accessor :next

  def initialize(data, next_node=nil)
    @data = data
    @next = next_node
  end

  def has_next?
    !self.next.nil?
  end

  def smaller_than? data
    self.data < data
  end
end

class List
  attr_accessor :head

  def initialize
    @head = nil
  end

  def each
    item = @head
    while(item)
      yield item
      item = item.next
    end
  end

  def to_a
    response = []

    self.each {|node| response << node.data }

    response
  end

  def insert(data)
    @head = Node.new(data, head)
  end

  def find_value(value)
    node = @head

    while(node)
      return true if node.data == value
      node = node.next
    end

    false
  end

  def insert_sorted(data)
    return insert(data) if list_empty?

    node = @head
    while(node.has_next? && node.next.smaller_than?(data))
      node = node.next
    end

    node.next = Node.new(data, node.next)
  end

  private
  def list_empty?
    @head == nil
  end

  def head
    @head
  end
end

require 'rspec'

describe Node do
  context '#last?' do
    it "tells if the node isn't the last one" do
      Node.new('xpto', Node.new('foo', nil)).has_next?.should be true
    end
  end

  context '#smaller_than?' do
    it 'tells if data of node is smaller than input' do
      Node.new(1,nil).smaller_than?(5).should be true
      Node.new(5,nil).smaller_than?(1).should be false 
    end
  end
end

describe List do
  before(:each) { @list = List.new }

  context '#insert' do
    it "adds a node" do
      @list.insert('bla')
      @list.instance_variable_get(:@head).data.should == 'bla'
    end
  end

  context '#to_a' do
    it "converts the list into an array" do
      @list.insert('bla')
      @list.insert('ble')

      @list.to_a.should == ['ble', 'bla']
    end
  end

  context '#each' do
    it "traverses the whole list" do
      @list.insert('bla')
      @list.insert('ble')

      res = []

      @list.each{|node| res << node.data }

      res.should include 'bla'
      res.should include 'ble'
    end
  end

  context '#find_value' do
    it "finds if a value exists" do
      @list.insert('foo')
      @list.insert('bar')

      @list.find_value('foo').should be true
      @list.find_value('xpto').should be false
    end
  end

  context '#insert_sorted' do
    it "inserts a value and keeps the list sorted" do
      @list.insert_sorted(1)
      @list.insert_sorted(2)
      @list.insert_sorted(7)
      @list.insert_sorted(3)
      @list.to_a.should == [1,2,3,7]
    end
  end
end
