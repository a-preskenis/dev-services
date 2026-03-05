#!/bin/sh
# Wait for RedisInsight to be ready
until curl -sf http://redis-insight:5540/api/databases > /dev/null 2>&1; do
  sleep 2
done
# Add Redis only if no databases configured yet
count=$(curl -s http://redis-insight:5540/api/databases | grep -o '"id"' | wc -l)
if [ "$count" -eq 0 ]; then
  curl -s -X POST http://redis-insight:5540/api/databases \
    -H "Content-Type: application/json" \
    -d '{"name":"Local Redis","host":"redis","port":6379,"db":0}'
fi
