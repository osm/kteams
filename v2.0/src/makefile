SRC = $(wildcard *.q)
M4SRC = $(patsubst %.q,%.qc,$(SRC))

../qwprogs.dat: macros.m4f $(M4SRC)
	fastqcc

macros.m4f: macros
	m4 -P -Fmacros.m4f macros >/dev/null

$(M4SRC): macros.m4f
%.qc: %.q
	m4 -P -Rmacros.m4f $< >$@
