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
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE

class Arrow::Field
  def self.new(name : String, data_type : Symbol, *args)
    dtype = case data_type
            when :int8
              Arrow::Int8DataType.new
            when :uint8
              Arrow::UInt8DataType.new
            when :int16
              Arrow::Int16DataType.new
            when :uint16
              Arrow::UInt16DataType.new
            when :int32
              Arrow::Int32DataType.new
            when :uint32
              Arrow::UInt32DataType.new
            when :int64
              Arrow::Int64DataType.new
            when :uint64
              Arrow::UInt64DataType.new
            when :bool
              Arrow::BooleanDataType.new
            when :dictionary
              Arrow::DictionaryDataType.new
            when :float
              Arrow::FloatDataType.new
            when :double
              Arrow::DoubleDataType.new
            when :date32
              Arrow::Date32DataType.new
            when :date64
              Arrow::Date64DataType.new
            when :extension
              Arrow::ExtensionDataType.new
            when :null
              Arrow::NullDataType.new
            when :string
              Arrow::StringDataType.new
            else
              raise "Invalid Symbol for DataType"
            end
    new(name, dtype)
  end
end
