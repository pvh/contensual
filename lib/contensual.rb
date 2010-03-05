module Contensual

class TableOfContents
  attr_reader :documents

  def initialize &block
    @documents = []
    block.arity < 1 ? instance_eval(&block) : yield(self) if block_given?
  end

  def self.load file
    toc = new
    toc.instance_eval IO.read(file), file
    toc
  end

  def document name, &block
    Document.new(self, name, &block).tap do |d|
      documents << d
    end
  end

  def length
    documents.length
  end
end

class Document
  attr_reader :name
  attr_reader :title
  attr_reader :pages

  def initialize toc, name, &block
    @toc = toc
    @name = name
    @pages = []

    block.arity < 1 ? instance_eval(&block) : yield(self) if block_given?
  end  

  def page name, &block
    Page.new(self, name, &block).tap do |p|
      pages << p
    end
  end

  def title title = nil
    title ? @title = title : @title
  end

  def length
    pages.length
  end

  def index
    @toc.documents.find_index { |d| d.name == @name }
  end

  def next
    @toc.documents[index + 1] if index < @toc.length
  end

  def prev
    @toc.documents[index - 1] if index > 0
  end
end

class Page
  attr_reader :name
  attr_reader :title

  def initialize document, name, &block
    @document = document
    @name = name

    block.arity < 1 ? instance_eval(&block) : yield(self) if block_given?
  end

  def full_path path = nil
    # todo
    path ? @path = path : @path
  end

  def title title = nil
    title ? @title = title : @title
  end

  def index
    @document.pages.find_index { |p| @name == p.name }
  end

  def next
    if index < @document.length - 1
      @document.pages[index + 1]
    elsif @document.next
      @document.next.pages.first
    else
      nil
    end
  end

  def prev
    if index > 0
      @document.pages[index - 1]
    elsif @document.prev
      @document.prev.pages.last
    else
      nil
    end
  end

  def render
    # todo
  end

  def to_s
    @title
  end
end

end
