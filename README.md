# GToolkit-Glutin

GToolkit bindings to [Glutin](https://github.com/rust-windowing/glutin) - a low-level library for OpenGL context creation, written in pure Rust.

## Installation

```smalltalk 
EpMonitor current disable.
[ 
  Metacello new
    baseline: 'Glutin';
    repository: 'github://feenkcom/gtoolkit-glutin/src';
    load
] ensure: [ EpMonitor current enable ].  
```
