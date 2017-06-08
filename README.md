Dockerized Nginx Container with Vault Integration
=================================================

This container is designed to work with existing [Hashicorp Vault](https://www.vaultproject.io/) infrastructure.<br>
Specifically: it will dynamically configure itself at run time with content in Vault.<br>
A set of environment variables tell the container which Vault instance to use, and which path to fetch secrets from.

If no secrets can be fetched, the default hardcoded values are used.

## Preparation

Seed your vault instance with the appropriate configuration files.<br>
For example:
```
    $ vault write secret/ngnix-instance-1/default.conf value=@myfile.txt
    $ vault write secret/ngnix-instance-1/cert value=@mycert.crt
    $ vault write secret/ngnix-instance-1/key value=@mykey.key
```

## Start the Container, using the correct environment variables

You'll need to generate a vault token for your application instance, and tell the ngnix container where it is and how to authenticate:

```

    $ docker run -it \
        -e TOKEN="c44a455e-9ecf-40f0-8d16-3368e5cca33c" \
        -e URL=https://vaultinstance.com:8200 \
        -e INDEX=nginx-instance-1 \
        niallbyrne\ngnix

```
