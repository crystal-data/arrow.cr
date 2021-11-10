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

class Arrow::ArrayBuilder
  # Builds an Arrow::Array from an `Enumerable`, returning
  # the un-casted Arrow::Array as a result.
  #
  # ## Arguments
  #
  # * values : `Enumerable` - Values with which to build the array,
  #   the builder class will be inferred from these values
  #
  # ## Examples
  #
  # ```
  # b = Arrow::ArrayBuilder.build(["Hello", nil, "World"])
  # s = Arrow::StringArray.cast(b)
  #
  # puts s.string(0) # => "Hello"
  # ```
  def self.build(values : Enumerable)
    info = {builder: Arrow::NullArrayBuilder.new, detected: false}
    values.each do |v|
      info = self.detect_builder_info(v)
      break if info[:detected]
    end
    info[:builder].from_array(values)
  end

  private def self.detect_builder_info(value)
    case value
    when nil
      {builder: Arrow::NullArrayBuilder.new, detected: false}
    when true, false
      {builder: Arrow::BooleanArrayBuilder.new, detected: true}
    when String
      {builder: Arrow::StringArrayBuilder.new, detected: true}
    when Float32
      {builder: Arrow::FloatArrayBuilder.new, detected: true}
    when Float64
      {builder: Arrow::DoubleArrayBuilder.new, detected: true}
    when Int8
      {builder: Arrow::Int8ArrayBuilder.new, detected: true}
    when UInt8
      {builder: Arrow::UInt8ArrayBuilder.new, detected: true}
    when Int16
      {builder: Arrow::Int16ArrayBuilder.new, detected: true}
    when UInt16
      {builder: Arrow::UInt16ArrayBuilder.new, detected: true}
    when Int32
      {builder: Arrow::Int32ArrayBuilder.new, detected: true}
    when UInt32
      {builder: Arrow::UInt32ArrayBuilder.new, detected: true}
    when Int64
      {builder: Arrow::Int64ArrayBuilder.new, detected: true}
    when UInt64
      {builder: Arrow::UInt64ArrayBuilder.new, detected: true}
    else
      {builder: Arrow::NullArrayBuilder.new, detected: false}
    end
  end

  # Builds an `Arrow::Array` from an `Enumerable`, returning
  # the un-casted Arrow::Array as a result.  This requires an
  # instance of a specific builder class, since Arrow::ArrayBuilder
  # does not implement append operations
  #
  # ## Arguments
  #
  # * values : `Enumerable` - Values with which to build the `Arrow::Array`
  #
  # ## Examples
  #
  # ```
  # b = Arrow::StringArrayBuilder.new
  # arr = b.from_array(["Hello", nil, "World"])
  # s = Arrow::StringArray.cast(arr)
  #
  # puts s.string(0) # => "Hello"
  # ```
  def from_array(values : Enumerable)
    values.each do |value|
      case value
      when Nil
        append_null
      else
        if self.responds_to?(:convert_to_arrow_value)
          append(self.convert_to_arrow_value(value))
        else
          append(value)
        end
      end
    end
    finish
  end

  # Appends values to the `Arrow::Array` managed by the `Arrow::ArrayBuilder`
  # from an `Enumerable`, also accepts a valid map to cast values to `nil`
  # if required.  This method is present on the `Arrow::ArrayBuilder` class
  # only to handle compile-time checks.
  def append_values(values : Enumerable, is_valids : Enumerable?); end

  # Appends a value to the `Arrow::Array` managed by the `Arrow::ArrayBuilder`
  # from an `Enumerable`. This method is present on the `Arrow::ArrayBuilder`
  # class only to handle compile-time checks.
  def append(value); end
end
