

require 'pathname'
require 'tempfile'

require 'bagit'
require 'zip'

require 'bagger/validator'


module Bagger
  class Worker
    include Bagger::Validator

    @queue = :bag_ingest

    def self.perform(institution_code, bag_file, dest_dir)
      worker = Bagger::Worker.new(institution_code, bag_file, dest_dir)
      worker.unzip
      worker.validate
      # worker.submit
      worker.clean_up
    end

    attr_reader :institution_code, :bag_file, :dest_dir, :bag

    def initialize(institution_code, bag_file, dest_dir)
      @institution_code = institution_code
      @bag_file         = bag_file
      @dest_dir         = dest_dir
    end

    def unzip
      puts "Unzipping #{@bag_file}"
      tmp = get_temp_path

      Zip::File.foreach(@bag_file) do |entry|
        output = tmp.join(entry.name)
        entry.extract(output.to_s)
      end

      bag_dir = tmp.join(Pathname.new(@bag_file).basename.to_s.split('.')[0])
      @bag = BagIt::Bag.new(bag_dir)
    end

    def clean_up
      puts "clean up #{@bag.bag_dir}"
      Pathname.new(@bag.bag_dir).rmtree
    end

    private

    def get_temp_path
      tmp_file = Tempfile.new('bag-ingest')
      tmp_path = tmp_file.path

      tmp_file.close
      tmp_file.unlink

      Pathname.new(tmp_path)
    end
  end
end

