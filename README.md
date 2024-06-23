Zig Brainf*ck Interpreter
---

## Building
`zig build`

## Running
`./zig-out/bin/bf`

## Notes
Executable accepts only 1 file, will ignore everything after.

## TODO
 - `,` (input instruction) not yet implemented
 - Possible memory fault if attempting to access a `address_ptr` > `UINT16_MAX`
