## Exercice 2

This is now time to compile and run your first unikernel!

In the `exo-2` directory, you should have 2 files:

- `config.ml` contains the unikernel configuration. It is used by
  `mirage configure` to properly configure the application backends:
   does it needs a network and/or storage stack, does it run on
   Unix or on Xen, etc...

- `unikernel.ml` contains the code of the application. The "business
  logic" goes there. The present application have an hard-coded proxy
  function, see `Hostname.decode`

To configure and build the unikernel:

### Configuration

```
mirage configure --net=socket
make
```

This will use the normal Unix sockets (e.g. the Linux network stack)
to route traffic to you application. See `mirage configure --help`
for the full list of configuration options.

### Run

You can now run your application:

```
sudo ./mir-exo-2
```

To see the result, point your browser to `http://localhost`.

Punch some ports and see how this changes:

```
telnet localhost 1000
# refresh the browser
telnet localhost 1001
# refresh the browser
```

The control port is `999` is you send `reset` to it, it will reset the
current port sequence.

### Run using the MirageOS network stack

Some workflow, but use:

```
mirage configure --dhcp=true
```

On OSX it will use the vmnet.framework to get an IP adress. On linux
it will use tun/tap. If you have `xen` installed on your machine you
can also run:

```
mirage configure --xen --dhcp=true
```

On OSX, you can download Vagrant images to have Xen emulation. Don't
worry too much about it, the whole point of MirageOS is to have a
seamless workflow between unix and xen.

### Task 2.1

Write a small stand-alone program (in OCaml of course!) to
convert a string given as input in a sequence of `telnet`
connection. Use `Hostname.encode`, `Sys.argv.(1)` and
`Sys.commmand`.

### Task 2.2

The actual purpose of exercice 2 is to connect the previous
`Hostname.decoding` to the current router: instead of having an
hard-coded port table, extend the `request` type to allow users
to register new hostnames.

A possible (very simple) protocol would be:

- the user sends "ascii-encoding" to the control port
- the user punches the sequence corresponding to an encoded hostname

Feel free to implement something more sophisticated

### Next

You can go to [Exercice 3](../exo-3/README.md)