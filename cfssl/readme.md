# cfssl

CFSSL is CloudFlare's PKI/TLS swiss army knife. It is both a command line tool and an HTTP API server for signing, verifying, and bundling TLS certificates.

Learn more at https://cfssl.org/ and https://github.com/cloudflare/cfssl

This docker image is extracted from [official docker image](https://github.com/cloudflare/cfssl/blob/master/Dockerfile.alpine), but runs the server instead of the cli at the cmd.

## How to use

### First time run

At first time, before running the container, you need to use cfssl to generate the ca keypair in advance.

First create a folder contating the config for your CA, such as `myCA`. Then create this config and name it `csr.json`. You may follow [this example](./exampleConfigs/xmj-alliance/csr.json).

Then you need to get the environment mount the config in.

To do this, you may:

- Run the container of this image manually, mount `myCA`, and override the program to execute. e.g. `docker run -it --rm -v /path/to/myCA:/csr ghcr.io/valorad/cfssl:latest sh`.

- (Or) Find and exec into an already running container of this image.

Then generate the ca keypair with:

``` shell
cfssl gencert -initca /path/to/myCA/csr.json | cfssljson -bare ca -
```

You will get the following files: `ca-key.pem, ca.csr, ca.pem`.

Name them to be `key.pem, csr.pem, cert.pem` respectively.

Copy `myCA` out, paste it to a place where you are going to mount it inside the new container.

This place is the `caConfigs` in the later context.

Create a root config following [this example](./exampleConfigs/xmj-alliance/config.json), name it `config.json` and place it inside `myCA`.

(Note that the expirary time [should not be more than 9528h][expDateMaxDays] (397 days) for server identification.)

Create a symlink within `caConfigs` folder, linking to `myCA`, name it `_activeCA`. Command: `ln -s myCA _activeCA`.

Create a db config file. Name it `db.json` and place it inside `caConfigs`. The example is available [here](./exampleConfigs/xmj-alliance/db.json). `data_source` can be any reachable folder that you can mount into the container.

Run a new container. You may do this:

- via docker-compose

  Refer to the [docker-compose example](docker-compose.run.example.yaml) and create your own.

- manually

``` shell
docker run -d \
--name cfssl-c1 \
--network main \
--user 1000 \
-v /path/2/caConfigs:/workspace/www/cfssl/configs \
-v /path/2/certstore/db:/workspace/www/cfssl/db \
ghcr.io/valorad/cfssl:latest
# The caConfigs is the folder containing all the CA configs,
# including the root CA, the intermediate CA,
# their keypairs,
# and all of the end-user entities that you going to create.
```

### Generate self-signed certificate without intermediate CA.

Exec into the running container.

Create new folder within `caConfigs`, where we will do all the certification stuffs inside related to your website. Name it such as `my.site`.

Create a csr inside the folder. Run the command:

``` shell
cd my.site
cfssl print-defaults csr > server.json
```
Then you will get something like:

``` json
{
    "CN": "example.net",
    "hosts": [
        "example.net",
        "www.example.net"
    ],
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "names": [
        {
            "C": "US",
            "ST": "CA",
            "L": "San Francisco"
        }
    ]
}
```

Modify the information to match your website. Pay extra attention to `hosts`, as this section translates to "X509v3 Subject Alternative Name", which will be used by browsers to verify the domain name of your site.

After the information is correctly provided, we genereate a server profile certificate:

``` shell
# Within "my.site" folder
cfssl gencert -ca=../_activeCA/cert.pem -ca-key=../_activeCA/key.pem -config=../_activeCA/config.json -profile=server ./server.json | cfssljson -bare my.site
```

Now we have the following files generated: `my.site-key.pem, my.site.csr, my.site.pem`

`my.site.pem` is the certificate that needs to be installed on client side.

Verify the certificate by running:

``` shell
# Run this outside the container. openssl is not installed inside container.
openssl x509 -in my.site.pem -text -noout
```

You get:

``` txt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            ...
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: C = NA, ST = TD, L = Zinia, O = Xiaomajia Alliance, OU = CA Services, CN = xmj-alliance
        Validity
            ...
        Subject: C = US, ST = CA, L = San Francisco, CN = my.site
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    ...
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            ...

            X509v3 Subject Alternative Name: 
                DNS:my.site, DNS:*.my.site, IP Address:192.168.1.100, IP Address:10.0.0.1
    Signature Algorithm: ...
```

Notice the issuer section is the root CA, and the Subject Alternative Name contains the correct IP, then we are good to go.

[expDateMaxDays]: https://stackoverflow.com/a/65239775/6514473