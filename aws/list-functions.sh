#!/bin/sh

exec aws lambda list-functions --no-cli-pager \
  --query 'Functions[*].[FunctionName]' --output text | sort
