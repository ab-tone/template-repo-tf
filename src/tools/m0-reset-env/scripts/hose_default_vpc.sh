#!/bin/sh
project_id="$1"
echo "Running hose_default_vpc for project '$project_id'"
vpcs=$(gcloud compute networks list --filter="name='default'" --format="value(name)")
for vpc in ${vpcs[@]}; do
  gcloud compute firewall-rules list --format="value(name)" \
    --filter="network='default'" \
    --project="${project_id}" | xargs gcloud compute firewall-rules delete -q
  gcloud -q compute networks delete default --project="${project_id}"
done
