Nginx Conjur Gatekeeper
========================

This example uses conjur and nginx to provide a gatekeeper for a simple webservice.

The example service accepts requests like `GET /fry/bacon` which corespond to performing
a priviliged action `fry` on a resource `bacon` with kind `service`.  The nginx lua code
checks that the current conjur user has this privilege before allowing the request.

 