- make sure you have docker and gtkwave.
- put your units in src and your testbenches in test.

let's say you have file `test/mux_tb.vhdl` that tests `src/mux.vhdl`, to compile and run it:

`$ ./run mux`

now you can view the wave file with:

`$ ./wave mux`

to clean the output:
`$ ./clean`
