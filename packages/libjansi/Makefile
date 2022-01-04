
all: libjansi.so

.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $<

libjansi.so: jansi.o jansi_isatty.o jansi_structs.o jansi_ttyname.o
	$(CC) $^ -shared -o $@ $(LDFLAGS) $(LIBS)

install: libjansi.so
	install -Dm700 -t $(PREFIX)/lib $^

clean:
	$(RM) *.o *.so
