# Configure the matchbox provider
provider "matchbox" {
  endpoint    = var.matchbox_rpc_endpoint
#  client_cert = file("~/.matchbox/local.client.crt")
#  client_key  = file("~/.matchbox/local.client.key")
#  ca          = file("~/.matchbox/local.ca.crt")
  client_cert = file("~/.matchbox/client.crt")
  client_key  = file("~/.matchbox/client.key")
  ca          = file("~/.matchbox/ca.crt")
}

