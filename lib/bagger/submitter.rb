

require 'fileutils'


module Bagger
  module Submitter
    def submit
      submit_dest
      submit_db
    end

    def submit_dest
      dest_dir = @dest_dir.join(@institution_code)
      puts "Submitting #{@bag_file} => #{dest_dir}"
      FileUtils.mv(@bag_file, dest_dir)
    end

    def submit_db

    end
  end
end

