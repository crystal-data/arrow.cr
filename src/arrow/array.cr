# Copyright (c) 2021 Crystal Data Contributors
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Base `Arrow::Array` class.  Instances of this class cannot be indexed,
# since the base class doesn't have a `value` method.
class Arrow::Array
  # Returns the value in an `Arrow::Array` at a given index, or `nil`
  # if the element is null.  This method is only present on the base
  # class to deal with compile time issues
  #
  # ## Arguments
  #
  # * i : `Int` - Index of element to return
  #
  # ## Examples
  #
  # ```
  # a = Arrow::ArrayBuilder.build([1, 2, 3])
  # i = Arrow::Int32Array.cast(a)
  # i.value(0) # => 1
  # ```
  def value(i : Int); end

  # Returns the value in an `Arrow::Array` at a given index, or `nil`
  # if the element is null.  This method is only present on the base
  # class to deal with compile time issues
  #
  # ## Arguments
  #
  # * i : `Int` - Index of element to return
  #
  # ## Examples
  #
  # ```
  # a = Arrow::ArrayBuilder.build([1, nil, 3])
  # i = Arrow::Int32Array.cast(a)
  # i[2] # => 3
  # i[1] # => nil
  # ```
  def [](i : Int)
    i += self.length if i < 0
    return nil if i < 0 || i >= self.length
    if self.null?(i)
      nil
    else
      value(i)
    end
  end

  # Yields the elements of an `Arrow::Array`.
  #
  # ## Examples
  #
  # ```
  # a = Arrow::ArrayBuilder.build([1, nil, 3])
  # i = Arrow::Int32Array.cast(a)
  # i.each do |el|
  #   puts el
  # end
  #
  # # 1
  # # nil
  # # 3
  # ```
  def each
    self.length.times do |i|
      yield self[i]
    end
  end

  # Converts the elements of an `Arrow::Array` to a standard library
  # Array.
  #
  # ## Examples
  #
  # ```
  # a = Arrow::ArrayBuilder.build([1, nil, 3])
  # i = Arrow::Int32Array.cast(a)
  # i.to_a(Int32) # => [1, nil, 3]
  # ```
  def to_a(dtype : U.class) : ::Array(U | Nil) forall U
    result = [] of U | Nil
    each do |v|
      result << v
    end
    result
  end

  # Returns an iterator through an `Arrow::Array`, as well as the
  # number of elements stored in the `Arrow::Array`.  Used primarily to
  # access the raw Crystal pointer associated with an `Arrow::Array`
  #
  # ## Examples
  #
  # ```crystal
  # arr = Arrow::Int32Array.new [1, 2, 3]
  # data, n = arr.values
  # puts data.array[1] # => 2
  # ```
  def values
    iterator = GObject::PointerIterator.new(Pointer(Int32).null) do |i|
      i
    end
    {iterator, 0}
  end
end

macro build_array_constructors
  {% for dtype in [
                    Int8,
                    UInt8,
                    Int16,
                    UInt16,
                    Int32,
                    UInt32,
                    Int64,
                    UInt64,
                    "Boolean",
                    "Dictionary",
                    Float,
                    "Double",
                    String,
                    "Date32",
                    "Date64",
                    "Extension",
                    "Null",
                  ] %}
    class Arrow::{{dtype.id}}Array
      def self.new(ary : ::Array)
        result = Arrow::ArrayBuilder.build(ary)
        Arrow::{{dtype.id}}Array.cast(result)
      end
    end
  {% end %}
end

build_array_constructors
