#!/usr/bin/env ruby
# frozen_string_literal: true

require 'byebug'
require 'avro_turf'
require 'dotenv'
require 'avro/builder'
require 'avro_turf/confluent_schema_registry'

Dotenv.load

schema_path = File.join(__dir__, 'avro', 'dsl')

store = Avro::Builder::SchemaStore.new(path: schema_path)

registry = AvroTurf::ConfluentSchemaRegistry.new(
  ENV.fetch('REGISTRY_URL'),
  user: ENV.fetch('API_KEY'),
  password: ENV.fetch('API_SECRET')
)

schema_names = Dir.entries(schema_path)
                  .select { _1.match(/\w*.rb\z/) }
                  .map { _1.gsub(/.rb/, '') }

schema_names.each do |schema_name|
  schema = store.find(schema_name)
  abort("incompatible evolution for schema: #{schema_name}") if !registry.compatible?(schema_name, schema)
end
