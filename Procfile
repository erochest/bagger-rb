ingest: bundle exec ./bin/bag-ingest ./landing ./s3
process: bundle exec rake -f Rakefile.worker resque:work
