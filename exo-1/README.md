## Exercice 1

The proxy that we want to write is programmable by sending a sequence of events
to its ports. For instance, if we want it to proxy http://google.com, it first
needs to be "prepared" by running the sequence:

```
telnet <proxy-ip> <root-port + 104> # character 'h'
telnet <proxy-ip> <root-port + 116> # character 't'
telnet <proxy-ip> <root-port + 116> # character 't'
telnet <proxy-ip> <root-port + 112> # character 'p'
...
telnet <proxy-ip> <root-port + 99>  # character 'c'
telnet <proxy-ip> <root-port + 111> # character 'o'
telnet <proxy-ip> <root-port + 109> # character 'm'
```

### Task 1.1

The first task is very simple and does not involve unikernels. You just need to
write the decoder and encoder from hostname to port sequence. See
[hostname.ml](./hostname.ml)

### Next

Once this is complete, you can go [Exercice 2](../exo-2/README.md)