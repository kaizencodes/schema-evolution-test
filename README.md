# schema-evolution-test

Proof of concept of using [Confluent Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html) in a Semaphore workflow.

## Usage

To test it yourself you need to do the following:

1. Register on [confluent cloud](https://www.confluent.io/get-started/?product=cloud)
Note: You don't need to, kafka and the registry can be self hosted, but this is the easiest way to do it.

2. Set up a cluster and schema registry. Make sure to set the compatibility mode (`FULL` recommended)
3. Generate api credentials.
4. Setup a new semaphore project and workflow.
5. Add the `API_KEY` and `API_SECRET` and `REGISTRY_URL` variables from your confluent cloud.
  - I've set up semaphore to store them in secrets, but you can also set them in env_vars, up to you. Just make sure to change the workflow accordingly.
  - For local testing create a .env and store the variables there.
6. Use the evolve.rb script to register the schemas. It takes the schema name as argument. `./evolve.rb order_created`
7. Make a new pr change the schemas, compatible changes should have a green semaphore check, incompatible changes should have red.
