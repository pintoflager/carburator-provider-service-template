#!/usr/bin/env bash

carburator print terminal info "Invoking $SERVICE_PROVIDER_NAME service provider..."

###
# Run the provisioner and hope it succeeds. Provisioner function has
# retries baked in (if enabled in provisioner.toml).
#
carburator provisioner request \
    service-provider \
    destroy \
    project \
    --provider "$SERVICE_PROVIDER_NAME" \
    --provisioner "$PROVISIONER_NAME" || exit 120

carburator print terminal info \
    "Destroying $SERVICE_PROVIDER_NAME service provider environment..."

carburator print terminal success \
    "$SERVICE_PROVIDER_NAME service provider environment destoryed."
