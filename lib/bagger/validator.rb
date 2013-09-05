
module Bagger
  module Validator
    def validate
      puts "#{@bag.bag_dir} validator"
      validate_structure
      validate_manifest
      puts "#{@bag.bag_dir} validator: OK"
    end

    def validate_structure
      nil
    end

    def validate_manifest
      raise "Invalid bag #{@bag.bag_dir}" unless @bag.complete? && @bag.consistent?
    end
  end
end



