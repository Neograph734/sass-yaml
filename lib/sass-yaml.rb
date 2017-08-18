require 'yaml'

module Sass::Script::Functions
# @param [Hash]  value
# @return [Sass::Script::Value::Map or Sass::Script::Value::List] 
  def convert_to_base(value) # part of this function is copied from https://github.com/fabiofabbrucci/sass-yaml/blob/master/lib/sass-yaml.rb
    if value.is_a?(String) 
      return Sass::Script::Value::String.new(value.to_s)
    elsif value.is_a?(Fixnum) 
      return Sass::Script::Value::Number.new(value)
    elsif value.is_a?(Array)
      value.each_with_index do |elem, i|
        value[i]= Sass::Script::Value::String.new(elem.to_s)
      end
      return Sass::Script::Value::List.new(value)
    elsif value.is_a?(Hash)
      result = Hash.new
      value.each {|the_key, the_value|
        result[convert_to_base(the_key)]=convert_to_base(the_value)
      }
      return Sass::Script::Value::Map.new(result)
    end
    p 'Error parsing ' + value.class
  end

  def yaml_load(file_name)
    # Required because the filename is escaped twice: "\"path/to/file\""
    file_name = file_name.to_s[1..-2]
    if (File.file?(file_name))
      file_content = YAML.load_file(file_name)
      if (file_content.is_a?(Hash))
        return convert_to_base(file_content)
      end
      p 'Parse YAML content.'
    else
      p 'The requested file could not be found.'
    end
  end
end
