# WebAuthn hosting for autodo.scirats.com

Deploy `hosting/.well-known/apple-app-site-association` at:

    https://autodo.scirats.com/.well-known/apple-app-site-association

It must be served over HTTPS with `Content-Type: application/json` and no redirects. This file associates the iOS app (`FJPAF4M87L.com.llamocca.autodo`) with the WebAuthn RP ID `autodo.scirats.com`.

The daemon itself can remain private on LAN/ZeroTier; this static file only establishes the app/domain association.
