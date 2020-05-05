import 
  osproc, streams, os, strutils


const
  command = "/opt/cisco/anyconnect/bin/vpn"


proc run_process(command: string): int =
  let pid = startProcess(
    command,
    options = {poEvalCommand, poInteractive}
  )

  let outStream = pid.outputStream
  var line = ""
  var rez = ""

  while pid.running:
    try:
      let streamRes = outStream.readLine(line)
      if streamRes:
        echo line
        rez = rez & "\n" & line
      else:
        # should mean stream is finished, i.e. process stoped
        sleep 10
        if not pid.running:
          break
    except IOError, OSError:
      echo "IOError"
      # outstream died on us?

  # try:
  #   if not outStream.atEnd():
  #     let rem = outStream.readAll()
  #     rez &= rem
  #     for line in rem.split("\n"):
  #       echo line
  # except:
  #   discard

  close(pid)
  let exitCode = pid.peekExitCode
  return exitCode


proc connect*(connStr: string, profile: string) {.raises: [OSError, Exception].} =
  if not run_process(r"printf " & connStr & r" | " & 
    command & r" -s connect " & profile) == 0:
      echo "Failed to run command"


proc disconnect*() {.raises: [OSError, Exception].} =
  if not run_process(command & r" disconnect") == 0:
    echo "Failed to run command"


proc profiles*() {.raises: [OSError, Exception].} =
  if not run_process(command & r""" hosts | grep ">" | cut -d " " -f 6""") == 0:
    echo "Failed to run command"


proc status*() {.raises: [OSError, Exception].} =
  if not run_process(command & r" status") == 0:
    echo "Failed to run command"

