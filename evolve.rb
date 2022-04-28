#!/usr/bin/env ruby
# frozen_string_literal: true

require 'byebug'
require 'avro_turf'
require 'dotenv'
require 'avro/builder'
require 'avro_turf/confluent_schema_registry'

if ARGV.length < 1
  puts "Provide the schema name to evolve"
  exit
end

Dotenv.load

schema_path = File.join(__dir__, 'avro', 'dsl')

store = Avro::Builder::SchemaStore.new(path: schema_path)

registry = AvroTurf::ConfluentSchemaRegistry.new(
  ENV.fetch('REGISTRY_URL'),
  user: ENV.fetch('API_KEY'),
  password: ENV.fetch('API_SECRET')
)

begin 
  schema_name = ARGV[0]
  registry.register(schema_name, store.find(schema_name))
rescue Avro::Builder::FileHandler::FileNotFoundError
  abort("schema not found: #{schema_name}")
rescue Excon::Error::Conflict
  abort("incompatible evolution for schema: #{schema_name}")
end
