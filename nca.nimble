# Package

version       = "0.1.0"
author        = "misterbianco"
description   = "A cli for cisco anyconnect"
license       = "MIT"
srcDir        = "src"
bin           = @["nca"]



# Dependencies
requires "nim >= 1.0.6"
requires "keyring >= 0.1.1"
requires "shell >= 0.3.0"
