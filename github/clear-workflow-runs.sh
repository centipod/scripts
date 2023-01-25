#!/bin/bash

# Source: https://stackoverflow.com/users/7690356/ribeiro
# Author: Ribeiro
# Required: gh, jq

# Prep on MacOS:
# - Install HoweBrew
# - brew install jq
# - brew install gh
# - gh auth login
# - Manually disable your workflows via github.com

org=<your github organisation or account>
repo=<your repository>

# Get workflow IDs with status "disabled_manually"
workflow_ids=($(gh api repos/$org/$repo/actions/workflows | jq '.workflows[] | select(.["state"] | contains("disabled_manually")) | .id'))

for workflow_id in "${workflow_ids[@]}"
do
  echo "Listing runs for the workflow ID $workflow_id"
  run_ids=( $(gh api repos/$org/$repo/actions/workflows/$workflow_id/runs --paginate | jq '.workflow_runs[].id') )
  for run_id in "${run_ids[@]}"
  do
    echo "Deleting Run ID $run_id"
    gh api repos/$org/$repo/actions/runs/$run_id -X DELETE >/dev/null
  done
done

# If this does not work:
# 1. Run this command to get all workflow IDs:
#   curl -X GET https://api.github.com/repos/<account>/<repo>/actions/runs?per_page=200 -H "Accept: application/json" -H "Authorization: Bearer <personal access token>"
# 2. And for each workflow ID, run this:
#   curl -X DELETE https://api.github.com/repos/<account>/<repo>/actions/runs/<id> -H "Accept: application/json" -H "Authorization: Bearer <personal access token>"
