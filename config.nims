requires "nim >= 1.2.0"
requires "keyring >= 0.1.1"
requires "nake >= 0.1.0"


hint("Processing", false)


if defined(windows):
    quit("You should you a better operating system", QuitFailure)


static:
  echo "------------------------------------------------------"
  echo "nca - A cli for cisco anyconnect"
  echo "------------------------------------------------------"
  echo "Tired of entering your password everytime your"
  echo "computer falls asleep or after some time has passed"
  echo "but dont want to make security mad? Just want to be"
  echo "able to use your keychain to store your password?"
  echo "Hey lady have I got a deal for you."
  echo ""
  echo "+ Verify that shell and keyring is installed"
  echo ""
  echo "+ If you compile this and get the error:"
  echo "  Error: cannot open file: ???"
  echo ""
  echo "+ You are missing dependencies"
  echo "  This is done with: "
  echo "  > nimble install"
  echo "  this will install all dependencies"
  echo ""
  echo "------------------------------------------------------"

task clean, "Clean artifacts":
    try:
        exec "rm nca"
    except OSError:
        discard


task strip, "Strip the binary (naughty naughty)":
    exec "strip nca"


task pack, "Run the upx packer on executable":
    exec "upx nca"


task install, "Install dependency":
    exec "nimble install"


task build, "Build command":

    # settings for sms instead of push notifications
    when defined(sms):
        echo "2Factor auth through sms"
        switch("d", "sms")
    else:
        echo "2Factor auth through push"


    when defined(strict):
        switch("styleCheck", "hint")


    # settings for production builds
    when defined(danger):
        echo "danger"
        switch("d", "release")
        switch("d", "danger")
        switch("opt", "size")


    elif defined(release):
        echo "release"
        switch("d", "release")
        switch("opt", "size")


    when defined(arc):
        switch("gc", "arc")
        switch("exceptions", "setjmp")

    switch("passC", "-flto")
    switch("o", "nca")
    
    setCommand("c")
