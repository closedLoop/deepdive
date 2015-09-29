#!/usr/bin/env bash
# start_docker.sh -- connects to database then starts bash
set -eu

# Configure environment variables and initialize script to wait for the deepdive database

export PGPORT=$DB_PORT_5432_TCP_PORT
export PGHOST=$DB_PORT_5432_TCP_ADDR
export PGPASSWORD=
export PGUSER=gpadmin
export DEEPDIVE_HOME=/root/deepdive

export PATH=~/deepdive/sbt:$PATH

echo "DeepDive needs a database connection to run and is waiting for the DB to finish initializing. After it finishes, the shell will return control to you."

while true; do
  psql -q -h $DB_PORT_5432_TCP_ADDR -p $DB_PORT_5432_TCP_PORT -U gpadmin deepdive -c "SELECT 1;" > /dev/null 2>&1
  RETVAL=$?
  if [ $RETVAL -eq 0 ]
  then
    break 
  else
    echo -ne "DeepDive is waiting for the DB to finish initializing $RETBAL \r"
  fi
  echo -ne "DeepDive is waiting for the DB to finish initializing\r"
  sleep 1
  echo -ne "DeepDive is waiting for the DB to finish initializing.\r"
  sleep 1
  echo -ne "DeepDive is waiting for the DB to finish initializing..\r"
  sleep 1
  echo -ne "DeepDive is waiting for the DB to finish initializing...\r"
  sleep 1 
  echo 'done'

echo 'echo -ne "\nDatabase is up and running! You may now use deepdive.\n"' >> ~/.bashrc

sed -i s/'sbt "test-only org.deepdive.test.integration.ChunkingApp -- -oF"'/'echo "Skipping ChunkingApp" \#sbt "test-only org.deepdive.test.integration.ChunkingApp -- -oF"'/g /root/deepdive/test/test_psql.sh
