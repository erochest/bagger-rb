
module Bagger
  class Worker
    @queue = :bag_ingest

    def self.perform(institution_code, bag_file)
      puts "Processing #{bag_file} for #{institution_code}."
    end
  end
end

