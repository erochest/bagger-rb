

require 'fileutils'

require 'active_record'

require 'bag'
require 'institution'


module Bagger
  module Submitter
    def submit
      submit_dest
      submit_db
    end

    attr_reader :dest_file

    def submit_dest
      bag_file   = Pathname.new @bag_file
      dest_dir   = @dest_dir.join(@institution_code)
      @dest_file = dest_dir.join(bag_file.basename)
      puts "Submitting #{@bag_file} => #{@dest_file}"
      FileUtils.mkdir(dest_dir) until Dir.exists?(dest_dir)
      FileUtils.mv(@bag_file, @dest_file)
    end

    def submit_db
      ActiveRecord::Base.establish_connection(@db_config)
      begin
        inst = Institution.find_by_code(@institution_code)
        Bag.create(
          institution: inst,
          path: @dest_file.realpath.to_s
        )
      rescue
        ActiveRecord::Base.remove_connection
      end
    end
  end
end

