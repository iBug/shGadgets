#!/bin/sh

if [ -z "$1" ]; then
  exit 1
fi

now=$(date +%s)
time_range="${2:-3600}"
function_name="$1"

query_id=$(aws logs start-query \
  --log-group-name "/aws/lambda/$function_name" \
  --start-time "$((now - time_range))" \
  --end-time "$now" \
  --query-string 'parse @log /(?<@name>[^\/]*)$/
| fields @timestamp, @message
| filter @message like /^(\S+\s*)?\{/
| sort @timestamp desc
| limit 20
' | jq -r .queryId)

f=/tmp/aws-logs.json
while true; do
  aws logs get-query-results --query-id "$query_id" > "$f" || exit 1
  status="$(jq -r .status "$f")"
  test "$status" = "Complete" && break
done
jq '.results | map(map(.key=.field) | from_entries | del(.["@ptr"]) | .["@message"] = (.["@message"] | fromjson))' "$f"
