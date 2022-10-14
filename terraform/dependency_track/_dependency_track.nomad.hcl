#
# Inspired by:
# https://raw.githubusercontent.com/DependencyTrack/dependency-track/HEAD/src/main/docker/docker-compose.yml
#
variable "datacenter" {}
variable "dns_resolver_ipv4" {}
variable "domain" {}

job "dependency_track_api" {
  datacenters = [var.datacenter]

  type = "service"

  group "api" {

    count = 1

    network {
      mode        = "bridge"
      dns         { servers = [var.dns_resolver_ipv4] }
      port "api-http"   { 
        to = 8080 
      }
    }

    service {
      name = "dependency-track-api"
      port = "api-http"
      connect {
        sidecar_service {
          proxy {
            local_service_port = 8080
          }
        } 
      }
    }
 
    task "apiserver" {
      driver = "docker"
      config {
        image = "dependencytrack/apiserver"
        ports = ["api-http"]
      }
      resources {
        cpu    = 1000 # MHz
        memory = 5120 # MB
      }

      env {
    # Database Properties
    # - ALPINE_DATABASE_MODE=external
    # - ALPINE_DATABASE_URL=jdbc:postgresql://postgres10:5432/dtrack
    # - ALPINE_DATABASE_DRIVER=org.postgresql.Driver
    # - ALPINE_DATABASE_USERNAME=dtrack
    # - ALPINE_DATABASE_PASSWORD=changeme
    # - ALPINE_DATABASE_POOL_ENABLED=true
    # - ALPINE_DATABASE_POOL_MAX_SIZE=20
    # - ALPINE_DATABASE_POOL_MIN_IDLE=10
    # - ALPINE_DATABASE_POOL_IDLE_TIMEOUT=300000
    # - ALPINE_DATABASE_POOL_MAX_LIFETIME=600000
    #
    # Optional LDAP Properties
    # - ALPINE_LDAP_ENABLED=true
    # - ALPINE_LDAP_SERVER_URL=ldap://ldap.example.com:389
    # - ALPINE_LDAP_BASEDN=dc=example,dc=com
    # - ALPINE_LDAP_SECURITY_AUTH=simple
    # - ALPINE_LDAP_BIND_USERNAME=
    # - ALPINE_LDAP_BIND_PASSWORD=
    # - ALPINE_LDAP_AUTH_USERNAME_FORMAT=%s@example.com
    # - ALPINE_LDAP_ATTRIBUTE_NAME=userPrincipalName
    # - ALPINE_LDAP_ATTRIBUTE_MAIL=mail
    # - ALPINE_LDAP_GROUPS_FILTER=(&(objectClass=group)(objectCategory=Group))
    # - ALPINE_LDAP_USER_GROUPS_FILTER=(member:1.2.840.113556.1.4.1941:={USER_DN})
    # - ALPINE_LDAP_GROUPS_SEARCH_FILTER=(&(objectClass=group)(objectCategory=Group)(cn=*{SEARCH_TERM}*))
    # - ALPINE_LDAP_USERS_SEARCH_FILTER=(&(objectClass=user)(objectCategory=Person)(cn=*{SEARCH_TERM}*))
    # - ALPINE_LDAP_USER_PROVISIONING=false
    # - ALPINE_LDAP_TEAM_SYNCHRONIZATION=false
    #
    # Optional OpenID Connect (OIDC) Properties
    # - ALPINE_OIDC_ENABLED=true
    # - ALPINE_OIDC_ISSUER=https://auth.example.com/auth/realms/example
    # - ALPINE_OIDC_CLIENT_ID=
    # - ALPINE_OIDC_USERNAME_CLAIM=preferred_username
    # - ALPINE_OIDC_TEAMS_CLAIM=groups
    # - ALPINE_OIDC_USER_PROVISIONING=true
    # - ALPINE_OIDC_TEAM_SYNCHRONIZATION=true
    #
    # Optional HTTP Proxy Settings
    # - ALPINE_HTTP_PROXY_ADDRESS=proxy.example.com
    # - ALPINE_HTTP_PROXY_PORT=8888
    # - ALPINE_HTTP_PROXY_USERNAME=
    # - ALPINE_HTTP_PROXY_PASSWORD=
    # - ALPINE_NO_PROXY=
    #
    # Optional HTTP Outbound Connection Timeout Settings. All values are in seconds.
    # - ALPINE_HTTP_TIMEOUT_CONNECTION=30
    # - ALPINE_HTTP_TIMEOUT_SOCKET=30
    # - ALPINE_HTTP_TIMEOUT_POOL=60
    #
    # Optional Cross-Origin Resource Sharing (CORS) Headers
        ALPINE_CORS_ENABLED = true
        ALPINE_CORS_ALLOW_ORIGIN = "*"
        ALPINE_CORS_ALLOW_METHODS = "GET, POST, PUT, DELETE, OPTIONS"
        ALPINE_CORS_ALLOW_HEADERS = "Origin, Content-Type, Authorization, X-Requested-With, Content-Length, Accept, Origin, X-Api-Key, X-Total-Count, *"
        ALPINE_CORS_EXPOSE_HEADERS = "Origin, Content-Type, Authorization, X-Requested-With, Content-Length, Accept, Origin, X-Api-Key, X-Total-Count"
        ALPINE_CORS_ALLOW_CREDENTIALS = true
        ALPINE_CORS_MAX_AGE = 3600
    #
    # Optional metrics properties
    # - ALPINE_METRICS_ENABLED=true      
      }
    }

  }
}
