#!/bin/sh

# -----------------------------------------------------------
# secure ngnix container - integrated with Vault for secret storage
# Maintained by:  niall@sharedvisionsolutions.com
# -----------------------------------------------------------

# ------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------

[[ -z ${TOKEN} ]] && echo "A valid TOKEN for accessing Vault was not specified in the environment." && exit 1
[[ -z ${URL} ]] && echo "A valid URL for accessing Vault was not specified in the environment." && exit 1
[[ -z ${INDEX} ]] && echo "A valid INDEX name for reading Vault secrets." && exit 1

# -----------------------------------------------------------
# Fetch Configuration From Vault
# -----------------------------------------------------------

override() {

    # $1 the remote key to fetch from vault
    # $2 the absolute path inside the container to save it as

    echo "Vault Lookup: ${URL}/v1/secret/${INDEX}/$1 : $2"
    json=$(curl -sH "X-Vault-Token:$TOKEN" -XGET ${URL}/v1/secret/${INDEX}/$1)
    if [[ $? -eq 0 ]]; then
        value=$(echo $json | jq -r .data.value)
        [[ "${value}" != "null" ]] && echo "Vault Lookup: Override found for $2" && echo "${value}" > $2
    fi

}

override ngnix.conf    /etc/nginx/ngnix.conf

override default.conf /etc/nginx/sites-enabled/default.conf

override ssl.conf     /etc/nginx/conf.d/ssl.conf
override cert         /etc/pki/cert.crt
override key         /etc/pki/key.key

# -----------------------------------------------------------
# Start Ngnix
# -----------------------------------------------------------

nginx
