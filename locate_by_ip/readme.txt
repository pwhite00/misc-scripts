locate_by_ip.rb 
===============
Version: 2.0

Why do we care and what are we doing. It's simple I use a vpn service but I
forget and this alows me to turn it on.

├── depricated
│   └── locate_by_ip.rb
├── locate_by_ip.rb
└── readme.txt



to build:

mac osx
$ env GOOS=darwin GOARCH=amd64 go build -o locate_by_ip.mac

linux x64
$ env GOOS=linux GOARCH=amd64 go build -o locate_by_ip.linux

linux arm
$ env GOOS=linux GOARCH=arm go build -o locate_by_ip.arm7


freebsd x64
env GOOS=freebsd GOARCH=amd64 go build -o locate_by_ip.freebsd