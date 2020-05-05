import 
  osproc


const
  command = "/opt/cisco/anyconnect/bin/vpn"


proc connect*(connStr: string, profile: string) {.raises: [Exception].} =
  echo execProcess(
    "printf " & connStr & " | " & 
    command & " -s connect " & profile
  )


proc disconnect*() {.raises: [Exception].} =
  echo execProcess(command & " hosts")


proc profiles*() {.raises: [Exception].} =
  echo execProcess(command & " hosts | grep \">\" | cut -d \" \" -f 6")


proc status*() {.raises: [Exception].} =
  echo execProcess(command & " status")

