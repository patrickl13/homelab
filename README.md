# homelab
My personal homelab setup


# Pre requisities

1. SSH private key
2. Raspberry Pi Ubuntu Server
3. Terraform installed
4. Docker installed


Run:
`sudo visudo`
add the following to the end of the file:
`your_username ALL=(ALL) NOPASSWD: /bin/mkdir, /bin/chown, /bin/chmod, /bin/cp`
