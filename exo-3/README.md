## Exercice 3

That new unikernel is similar to the previous one seen in Exercice 2, but it
links with the HTTP stack to act as a real proxy.

Run the proxy, checks that it works. Re-add your logic from exercice 2 to
program the ports.

### Task 3.1: command-line arguments

The control port is currently hard-coded. If you'd had to write a normal
command-line application, you could use the usual `Arg` module to parse
the command-line. However, as 1/ you don't have command-line arguments if
your program is running far away in the Cloud and 2/ you might want to pass
some arguments at configuration time (typically the control port), others at
runtime (maybe the default hostname?) and sometimes both.

Use the `Mirage_key` argument to new commands lines arguments for
`contorl-port` and `default-host`. See `mirage-skeleton/hello` for an
example, look at the doc and ask me.

### Task 3.2: mirage describe

Play with `mirage-describe`, admire the `dot` output. Pretty, hu?

### Task 3.3: run on Xen

Everything that you did should just works fine on Xen, e.g. with no
intermediate OS. You might gave to edit `exo-3.xl` to change the bridge
configuration (it might be `xenbr0`) and decrease the amount of RAM.
Use the `xl` command line to start the unikernel:

```
sudo xl create exo-3.xl
```

If you have OSX, use can try with that vagrant image:

```
https://github.com/mthurman/mirage-vagrant
```

or read Magnus' [blog post](http://www.skjegstad.com/blog/2015/01/19/mirageos-xen-virtualbox/)


### Taks 3.4 Multiple HTTP ports

It is easy to bind multiple HTTP port, try it. Try to extend the protocol on
the control port to manage multiple HTTP proxy:

- the user send "port <n>" to select which port is being programed to be an
  HTTP proxy.

Try it with static ports first, then try dynamic ones.

### Next

You can new use your imagination to create the most crazy proxy ever. Ask me if
you need some ideas :-)
