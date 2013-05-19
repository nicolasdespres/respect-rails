#!/bin/bash
#
# Some integration test in development mode.
# It tests that headers can be dumped in JSON. It happens when a request headers validation error is caught.

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
  -H "X-Test-Header: wrong" \
  "http://localhost:$PORT/caught_exception/headers_check.json" 2>&1)

kill -9 $(cat "$RAILS_ROOT/test/dummy/tmp/pids/server.pid")

if grep -q '^< HTTP/1.1 500 Internal Server Error' <<< "$result" && grep -q '^< Content-Type: application/json' <<< "$result"
then
  exit 0
else
  echo "$result"
  exit 1
fi
