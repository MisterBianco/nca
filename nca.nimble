# Package
import 
    strutils, strformat

version       = readFile("VERSION").strip()
license       = readFile("LICENSE")

author        = "misterbianco"
description   = "A cli for cisco anyconnect"
srcDir        = "src"
bin           = @["nca"]

# Dependencies
requires "nim >= 1.2.0"
requires "keyring >= 0.1.1"
requires "nake >= 0.1.0"


task release, "Build and publish a release":
    exec "git add ."
    exec "git commit -m 'release commit'"
    exec "git push"
    exec "nim build -d:arc -d:danger src/nca.nim"
    exec "strip nca"
    exec "upx nca"
    exec fmt"github-release create -t $GITHUB_TOKEN -o misterbianco -r nca --tag v{version}"
    exec fmt"github-release upload -t $GITHUB_TOKEN -o misterbianco -r nca --tag v{version} --file ./nca"
