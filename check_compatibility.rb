#!/usr/bin/env ruby

require 'byebug'
require 'avro_turf'
require 'dotenv'
require 'avro/builder'
require 'avro_turf/confluent_schema_registry'

Dotenv.load

base_path = File.expand_path(File.dirname(__FILE__))
schema_path = File.join(base_path, 'avro', 'dsl')

store = Avro::Builder::SchemaStore.new(path: schema_path)

registry = AvroTurf::ConfluentSchemaRegistry.new(
  ENV.fetch("REGISTRY_URL"),
  user: ENV.fetch("API_KEY"),
  password: ENV.fetch("API_SECRET"),
)

schema_names = Dir.entries(schema_path)
  .select{ _1.match(/\w*.rb\z/) }
  .map{ _1.gsub(/.rb/, "") }

schema_names.each do |schema_name|
  schema = store.find(schema_name)
  if !registry.compatible?(schema_name, schema)
    abort("incompatible evolution for schema: #{schema_name}") 
  end
end
