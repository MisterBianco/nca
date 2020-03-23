import
  keyring,
  posix,
  terminal


let
  userName* = $getpwuid(getuid()).pw_name

proc keyDeletePassword*(profile: string) {.raises: [OSError, IOError, Defect, Exception].} =
  deletePassword(profile, userName)


proc keySetPassword*(profile: string, password: string) {.raises: [OSError, Exception].} =
  setPassword(profile, userName, password)


proc keyGetPassword*(profile: string): string {.raises: [OSError, Exception].} =
  try:
    return getPassword(profile, userName).get()
  except UnpackError:
    echo "Password not found."
    var password = readPasswordFromStdin("Password: ")
    keySetPassword(profile, $password)
    return keyGetPassword(profile)
