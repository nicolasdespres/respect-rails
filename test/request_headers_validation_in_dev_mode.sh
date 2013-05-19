#!/bin/bash
#
# Test request headers check in development mode.
#

set -o errexit
set -o nounset

export LC_ALL=C

: ${RAILS_ROOT:=.}
: ${PORT:=3000}

(
  cd "$RAILS_ROOT/test/dummy"
  rails server --daemon --port=$PORT 2>&1 >/dev/null
  sleep 2
)

result=$(curl \
  -v \
  -H "X-Test-Header: value" \
  "http://localhost:3000/automatic_validation/check_request_headers.json" 2>&1)

kill -9 $(cat "$RAILS_ROOT/test/dummy/tmp/pids/server.pid")

if grep -q "^< HTTP/1.1 200 OK" <<< "$result"
then
  exit 0
else
  echo "$result"
  exit 1
fi
