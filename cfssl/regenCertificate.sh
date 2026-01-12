#!/bin/sh
# Note: Place this file to caConfigs folder!

# configs
sitesToGenCert="my.site.folder"

# functions
generateCertificate() {

  siteName=$1

  sitePath=$2

  activeCAPath=$3

  cfssl gencert \
    -ca="$activeCAPath/cert.pem" \
    -ca-key="$activeCAPath/key.pem" \
    -config="$activeCAPath/config.json" \
    -profile=server \
    "$sitePath/server.json" | cfssljson \
    -bare "$sitePath/$siteName"

}

renameCertFiles() {

  siteName=$1

  sitePath=$2

  mv "$sitePath/$siteName-key.pem" "$sitePath/key.pem"
  mv "$sitePath/$siteName.csr" "$sitePath/csr.pem"
  mv "$sitePath/$siteName.pem" "$sitePath/cert.pem"

}

main() {

  for site in ${sitesToGenCert}; do

    siteFolder="./$site"

    if [ -d $siteFolder ]
    then
      # generate key cert and csr pems
      generateCertificate $site $siteFolder "_activeCA"

      # rename all
      renameCertFiles $site $siteFolder

    else
        echo "Warning: Directory $siteFolder does not exist, therefore has been skipped. Make sure you run this script from caConfigs folder."
    fi

  done
}

# Execution
main
