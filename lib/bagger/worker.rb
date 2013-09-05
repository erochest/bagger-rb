

require 'pathname'
require 'tempfile'
require 'yaml'

require 'bagit'
require 'zip'

require 'bagger/submitter'
require 'bagger/validator'


module Bagger
  class Worker
    include Bagger::Submitter
    include Bagger::Validator

    @queue = :bag_ingest

    def self.perform(institution_code, bag_file, dest_dir)
      worker = Bagger::Worker.new(institution_code, bag_file, dest_dir)
      worker.unzip
      begin
        worker.validate
        worker.submit
      rescue
        worker.clean_up
      end
    end

    attr_reader :institution_code, :bag_file, :dest_dir, :bag, :db_config

    def initialize(institution_code, bag_file, dest_dir)
      @institution_code = institution_code
      @bag_file         = bag_file
      @dest_dir         = Pathname.new dest_dir
      @db_config        = read_db_config
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

    # TODO: The location and key should be configurable.
    def read_db_config
      config  = YAML.load_file('config/database.yml')
      config['development']
    end
  end
end

