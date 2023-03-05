# TLS certificates

## TLS endpoints

The TLS endpoints fo Vault, Consul and Nomad rely on an externaly built certificate that
needs to be trusted by the client browsers. 

At this stage of the project, the tutorial [](/tutorials/deploy_scw.md) relies on 
the fact that the deployed Hashistack should be exposed on the Internet and a DNS
challenge with LetsEncrypt give us the mandatory certificates (wildcard for the deployed domain).

This certificate is first issued on the `sre` host, then fetched on the ansible-controller 
to be redistributed on the other hosts.

## Service to service mTLS

Vault is configured to seed its own self-signed root PKI. The public part of this certificate is redistributed 
to all hosts and added to the trusted certificates at the system level.

That ensures transparent trust of all the short-lived certificate that Vault will issue to handle 
Consul's requests for its service mesh.

## Further improvements

Hashistack should soon offer the capability to supply your own certificate to seed the Vault PKI. That will enable
the capability to integrate Vault into an existent enterprise PKI.
