.PHONY: run
run: test.exe
	LD_LIBRARY_PATH=. valgrind ./test.exe

libmylib.so: mylib.ml
	ocamlopt -output-complete-obj -runtime-variant _pic -o libmylib.so -impl mylib.ml

test.exe: test.c libmylib.so
	gcc -I ${OPAM_SWITCH_PREFIX}/lib/ocaml -I. test.c -L. -lmylib -o test.exe

.PHONY: clean
clean:
	rm *.cm* *.o libmylib.so test.exe
