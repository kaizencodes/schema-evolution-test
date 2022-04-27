require 'byebug'
require 'avro_turf'
require 'dotenv'
require 'avro/builder'
require 'avro_turf/messaging'

Dotenv.load

base_path = File.expand_path(File.dirname(__FILE__))
schema_path = File.join(base_path, 'avro', 'dsl')

avro = AvroTurf::Messaging.new(
  registry_url: ENV["REGISTRY_URL"],
  user: ENV["API_KEY"],
  password: ENV["API_SECRET"], 
  schema_store: Avro::Builder::SchemaStore.new(path: schema_path))
registry = avro.instance_variable_get(:@registry)
store = avro.instance_variable_get(:@schema_store)

registry.compatible?("order_created", store.find("order_created"))
