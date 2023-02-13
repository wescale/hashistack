# Deploy stages

This stack's deployment has been designed in successive phases that have to be done in the right order for a platform
to become functional. This section describes the different stages that lead to a full deployment.

* Stage 0: Getting __infrastructure resources__ ready for install (host, default accounts, network, ...)
* Stage 1: __System services__ installation and configuration (NTP, SSH, DNS, ...)
* Stage 2: __Vault__ and __Consul__ installation and configuration
* Stage 3: __Nomad__ installation and configuration

