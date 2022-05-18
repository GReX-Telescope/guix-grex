# GReX Guix Packages

This repo provides the system configuration and associated packages for the GReX
Guix components

## Channel

To add the channel, add the following to your `~/.config/guix/channels.scm`

```scheme
(cons (channel
        (name 'guix-grex)
        (url "https://github.com/GReX-Telescope/guix-grex.git"))
      %default-channels)
```
