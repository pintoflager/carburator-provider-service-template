#!/usr/bin/env bash

carburator print terminal info "Invoking $SERVICE_PROVIDER_NAME service provider..."

# Provisioner defined with a parent command flag
provisioner="$PROVISIONER_NAME"

# ...Or take the first package provider has in it's packages list.
# with service / dns provider we know packages are provisioners.
if [[ -z $provisioner ]]; then
    provisioner="$SERVICE_PROVIDER_PACKAGES_0_NAME"
fi

# Lock in root user ssh key.
root_pubkey=$(carburator get env "${SERVICE_PROVIDER_NAME}_ROOT_PUBLIC_SSKEY" \
    -s "$SERVICE_PROVIDER_NAME" -p "$SERVICE_PROVIDER_NAME.env")

if [[ -z $root_pubkey ]]; then
    root_pubkey=$(carburator get env REGISTER_ROOT_PUBLIC_SSKEY_0 \
        -p .exec.env) || exit 120

    carburator put env "${SERVICE_PROVIDER_NAME}_ROOT_PUBLIC_SSKEY" "$root_pubkey" \
        -s "$SERVICE_PROVIDER_NAME" \
        -p "$SERVICE_PROVIDER_NAME.env" || exit 120
fi

if [[ -z $root_pubkey ]]; then
    carburator print terminal error \
        "Unable to find path to root public SSH key from .exec.env"
    exit 120
fi

###
# Run the provisioner and hope it succeeds. Provisioner function has
# retries baked in (if enabled in provisioner.toml).
#
carburator provisioner request \
    service-provider \
    create \
    project \
        --provider "$SERVICE_PROVIDER_NAME" \
        --provisioner "$provisioner" \
        --key-val "ROOT_SSH_PUBKEY=$root_pubkey" || exit 120

carburator print terminal success "$SERVICE_PROVIDER_NAME project created."
