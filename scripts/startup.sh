#! /bin/bash

# ./scripts/wait-for-services.sh
./scripts/prepare-db.sh
bundle exec rails server
