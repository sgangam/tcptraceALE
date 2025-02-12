#
# Makefile for tcptrace
#
srcdir = .
top_srcdir = .


################################################################## 
#
# tcptrace supports reading compressed files with a little help...
# 1) If your system has "gunzip", then uncomment the following line to
#    support on-the-fly decompression of ".gz" and ".Z" files...
DEFINES += -DGUNZIP="\"gunzip\""
# 2) Otherwise, if your system supports standard Unix "uncompress",
#    then uncomment the following line to support on-the-fly
#    decompression of ".Z" files...
#DEFINES += -DUNCOMPRESS="\"uncompress\""
# 3) Also, we assume most systems have the "bunzip2" utility installed,
#    if yours doesn't, you'll want to comment out the next line.
DEFINES += -DBUNZIP2="\"bunzip2\""
# - we'll do path search on the string you specify.  If the program
#    isn't in your path, you'll need to give the absolute path name.
# - if you want other formats, see the "compress.h" file.



################################################################## 
#
# If you want to read tcpdump output (which you probably do),
# you'll need the LBL PCAP library.  I've just listed a bunch
# of places that it might be (other than the standard
# location).  If it's somewhere else, just add it into the
# list.
# 
################################################################## 
PCAP_LDLIBS = -lpcap
PCAP_INCS    = -I/usr/local/include -I. -I../pcap -I/usr/include/pcap
PCAP_LDFLAGS = -L/usr/local/lib -Llib -Lpcap -L../pcap -L./cygwin-libs



################################################################## 
# 
# Plug-in modules.
# There's no reason that I can think of to remove them, but
# here they are.  Just comment them out to omit them from
# the binary.
# 
################################################################## 
# 
# Experimental HTTP analysis module
# 
DEFINES += -DLOAD_MODULE_HTTP -DHTTP_SAFE -DHTTP_DUMP_TIMES
# 
# Experimental overall traffic by port module
# 
DEFINES += -DLOAD_MODULE_TRAFFIC
# 
# Experimental traffic data by time slices module
# 
DEFINES += -DLOAD_MODULE_SLICE
# 
# Experimental round trip time graphs
# 
DEFINES += -DLOAD_MODULE_RTTGRAPH
# 
# Experimental tcplib-data generating module
#
# We are not going to compile in the antiquated TCPLIB module by default 
# anymore.
# It seems to have quite some bugs, and being antiquated as it is, we thought
# it is not worth the time fixing them. Uncomment this line and ./configure
# and make again,  if you really need the module. - Mani, 15 Aug 2003.
# DEFINES += -DLOAD_MODULE_TCPLIB
# 
# Experimental module for a friend
# 
DEFINES += -DLOAD_MODULE_COLLIE
# 
# Example module for real-time mode 
# 
DEFINES += -DLOAD_MODULE_REALTIME
#
# INBOUNDS module implements the functionality required for the INBOUNDS
# intrusion detection system project, Ohio University.
# ( Uncomment the following line before running configure to build it )
# DEFINES += -DLOAD_MODULE_INBOUNDS


################################################################## 
# 
# File formats that we understand.
# The only reason that I can see to remove one is if you don't
# have the PCAP library, in which case you can comment out
# GROK_TCPDUMP and still compile, but then you can't read the
# output from tcpdump.
# 
################################################################## 
# define GROK_SNOOP if you want tcptrace to understand the output
# format of Sun's "snoop" packet sniffer.
DEFINES += -DGROK_SNOOP
# define GROK_TCPDUMP if you want tcptrace to understand the output
# format format of the LBL tcpdump program (see the file README.tcpdump
# for other options)
DEFINES += -DGROK_TCPDUMP
# define GROK_NETM if you want tcptrace to understand the output
# format of HP's "netm" monitoring system's packet sniffer.
DEFINES += -DGROK_NETM
# define GROK_ETHERPEEK if you want tcptrace to understand the output
# format of the Macintosh program Etherpeek
DEFINES += -DGROK_ETHERPEEK
# define GROK_NS if you want tcptrace to understand the output
# format of the LBL network simulator, ns
DEFINES += -DGROK_NS
# define GROK_NLANR if you want tcptrace to understand the output
# format of the various NLANL tools
# (this doesn't work well yet, not recommended - Sat Dec 19, 1998)
# DEFINES += -DGROK_NLANR
# define GROK_NETSCOUT if you want tcptrace to understand ascii
# formatted netscout output files
DEFINES += -DGROK_NETSCOUT
# define GROK_ERF if you want tcptrace to understand the output
# format of the Endace Technology dagsnap program */
DEFINES += -DGROK_ERF

################################################################## 
# 
# Just a quick installation rule, not much to do
# 
################################################################## 
# Pathname of directory to install the binary
BINDIR = /usr/local/bin
MANDIR = /usr/local/man/


################################################################## 
################################################################## 
################################################################## 
# 
# You shouldn't need to change anything below this point
# 
################################################################## 
################################################################## 
################################################################## 

CC = gcc
CCOPT = -O2
INCLS = -I.  ${PCAP_INCS}

# Standard CFLAGS
# Probably want full optimization
# FreeBSD needs	-Ae
# HP needs	-Ae
CFLAGS = $(CCOPT) $(DEFINES) -DHAVE_LIBM=1 -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DSIZEOF_UNSIGNED_LONG_LONG_INT=8 -DSIZEOF_UNSIGNED_LONG_INT=8 -DSIZEOF_UNSIGNED_INT=4 -DSIZEOF_UNSIGNED_SHORT=2 -DHAVE_MKSTEMP=1 -DHAVE_VALLOC=1 -DHAVE_MEMALIGN=1 -DHAVE_INET_PTON=1 -DUSE_LLU=1   -D_BSD_SOURCE $(INCLS)

# Standard LIBS
LDLIBS = -lm  ${PCAP_LDLIBS}
# for solaris, you probably want:
#	LDLIBS = -lpcap -lnsl -lsocket -lm
# for HP, I'm told that you need:
#	LDLIBS = -lpcap -lstr -lm
# everybody else (that I know of) just needs:
#	LDLIBS = -lpcap -lm
# 
LDFLAGS += ${PCAP_LDFLAGS}



# for profiling (under Solaris, at least)
#CFLAGS	+= -pg
#LDFLAGS += /usr/lib/libdl.so.1


# Source Files
CFILES= avl.c compress.c erf.c etherpeek.c gcache.c mfiles.c names.c \
	netm.c output.c plotter.c print.c rexmit.c snoop.c nlanr.c \
	tcpdump.c tcptrace.c thruput.c trace.c ipv6.c	\
	filt_scanner.c filt_parser.c filter.c udp.c \
	ns.c netscout.c version.c pool.c poolaccess.c \
	dstring.c
MODULES=mod_http.c mod_traffic.c mod_rttgraph.c mod_tcplib.c mod_collie.c \
	mod_slice.c mod_realtime.c mod_inbounds.c
MODSUPPORT=dyncounter.c
OFILES= ${CFILES:.c=.o} ${MODULES:.c=.o} ${MODSUPPORT:.c=.o}

all: tcptrace versnum

tcptrace: ${OFILES}
	${CC} ${LDFLAGS} ${CFLAGS} ${OFILES} -o tcptrace ${LDLIBS}

#
# special rule for version.c
# needs to be recompiled EVERY time
#
# If you have problems getting "whoami", "hostname", or "date" to run on
# your machine, just hack in a quick string below in place of the command.
version.o: ${CFILES} Makefile
	${CC} ${CFLAGS} -o version.o -c $(srcdir)/version.c \
	-DBUILT_USER="\"`whoami`\"" -DBUILT_HOST="\"`hostname`\"" -DBUILT_DATE="\"`date`\""

#
# special rules for scanner/parser
#
# Note that I'm using the GNU bison/flex to get around the problems
# caused by the fact that that pcap library ALSO uses YACC, which can
# cause naming conflicts.  The Gnu versions let you get around that
# easily.
#
YACC_VAL=yacc
LEX_VAL=:

filt_parser.c: filt_parser.y filter.h
	if test "${YACC_VAL}" = "bison -y" ; then \
		yacc -vd -p filtyy -o filt_parser.c $(srcdir)/filt_parser.y ;\
		cp filt_parser.c flex_bison ;\
		cp filt_parser.h flex_bison ;\
	else \
		echo "Could not find BISON on this system";\
		echo "Copying the BISON output files generated at our place" ;\
		cp flex_bison/filt_parser.c . ;\
		cp flex_bison/filt_parser.h . ;\
	fi

filt_scanner.c: filt_scanner.l filter.h filt_parser.h
	if test ${LEX_VAL} = "flex" ; then \
		: -t -Pfiltyy $(srcdir)/filt_scanner.l > filt_scanner.c ;\
		cp filt_scanner.c flex_bison ;\
	else \
		echo "Could not find FLEX on this system" ;\
		echo "Copying the FLEX output files generated at our place" ;\
		cp flex_bison/filt_scanner.c . ;\
	fi

# filt_parser.h created as a side effect of running yacc...
filt_parser.h: filt_parser.c

# version numbering program
versnum: versnum.c version.h
	${CC} ${LDFLAGS} ${CFLAGS} $(srcdir)/versnum.c -o versnum ${LDLIBS}

#
# obvious dependencies
#
${OFILES}: tcptrace.h


#
# just for RCS
ci:
	ci -u -q -t-initial -mlatest *.c *.h \
		Makefile.in configure.in config.guess config.sub aclocal.m4 \
		README* INSTALL* CHANGES WWW COPYRIGHT

#
# for cleaning up
clean:
	rm -f *.o tcptrace versnum core *.xpl *.dat .devel \
		config.cache config.log config.status bin.* \
		filt_scanner.c filt_parser.c y.tab.h y.output PF \
		filt_parser.output filt_parser.h
	cd input; ${MAKE} clean

noplots:
	rm -f *.xpl *.dat

initial:
	cp Makefile.empty Makefile

spotless: clean noplots initial

#
# for making distribution
tarfile: versnum
	@VERS=`./versnum`; DIR=tcptrace.$${VERS}; \
	GZTAR=$$HOME/tcptrace.$${VERS}.tar.gz; \
	make spotless; \
	cd ..; \
	ln -s src $${DIR} 2>/dev/null ; \
	/usr/sbin/tar -FFcvhf - $${DIR} | gzip > $${GZTAR}; \
	echo ; echo "Tarfile is in $${GZTAR}"
#
# similar, but include RCS directory and etc
bigtarfile:
	cd ..; /usr/sbin/tar -cfv $$HOME/tcptrace.tar src

#
# just a quick installation rule
INSTALL = ./install-sh -c
install: tcptrace install-man
	$(INSTALL) -m 755 -o bin -g bin tcptrace ${BINDIR}/tcptrace
install-man: 
	$(INSTALL) -m 444 -o bin -g bin tcptrace.man $(MANDIR)/man1/tcptrace.1



#
# make development version
develop devel:
	touch .devel

configure: configure.in
	autoconf


#
# generate dependencies
depend:
	makedepend ${INCS} -w 10 *.c
#
# static file dependencies
#
avl.o: tcptrace.h
compress.o: tcptrace.h
compress.o: ipv6.h
compress.o: dstring.h
compress.o: pool.h
compress.o: compress.h
dstring.o: tcptrace.h
dstring.o: ipv6.h
dstring.o: dstring.h
dstring.o: pool.h
dyncounter.o: tcptrace.h
dyncounter.o: ipv6.h
dyncounter.o: dstring.h
dyncounter.o: pool.h
dyncounter.o: dyncounter.h
etherpeek.o: tcptrace.h
etherpeek.o: ipv6.h
etherpeek.o: dstring.h
etherpeek.o: pool.h
filt_parser.o: tcptrace.h
filt_parser.o: ipv6.h
filt_parser.o: dstring.h
filt_parser.o: pool.h
filt_parser.o: filter.h
filt_scanner.o: tcptrace.h
filt_scanner.o: ipv6.h
filt_scanner.o: dstring.h
filt_scanner.o: pool.h
filt_scanner.o: filter.h
filt_scanner.o: filt_parser.h
filter.o: tcptrace.h
filter.o: ipv6.h
filter.o: dstring.h
filter.o: pool.h
filter.o: filter.h
filter.o: filter_vars.h
gcache.o: tcptrace.h
gcache.o: ipv6.h
gcache.o: dstring.h
gcache.o: pool.h
gcache.o: gcache.h
ipv6.o: tcptrace.h
ipv6.o: ipv6.h
ipv6.o: dstring.h
ipv6.o: pool.h
mfiles.o: tcptrace.h
mfiles.o: ipv6.h
mfiles.o: dstring.h
mfiles.o: pool.h
names.o: tcptrace.h
names.o: ipv6.h
names.o: dstring.h
names.o: pool.h
names.o: gcache.h
netm.o: tcptrace.h
netm.o: ipv6.h
netm.o: dstring.h
netm.o: pool.h
netscout.o: tcptrace.h
netscout.o: ipv6.h
netscout.o: dstring.h
netscout.o: pool.h
nlanr.o: tcptrace.h
nlanr.o: ipv6.h
nlanr.o: dstring.h
nlanr.o: pool.h
ns.o: tcptrace.h
ns.o: ipv6.h
ns.o: dstring.h
ns.o: pool.h
output.o: tcptrace.h
output.o: ipv6.h
output.o: dstring.h
output.o: pool.h
output.o: gcache.h
plotter.o: tcptrace.h
plotter.o: ipv6.h
plotter.o: dstring.h
plotter.o: pool.h
pool.o: pool.h
poolaccess.o: tcptrace.h
poolaccess.o: ipv6.h
poolaccess.o: dstring.h
poolaccess.o: pool.h
print.o: tcptrace.h
print.o: ipv6.h
print.o: dstring.h
print.o: pool.h
rexmit.o: tcptrace.h
rexmit.o: ipv6.h
rexmit.o: dstring.h
rexmit.o: pool.h
snoop.o: tcptrace.h
snoop.o: ipv6.h
snoop.o: dstring.h
snoop.o: pool.h
tcpdump.o: tcptrace.h
tcpdump.o: ipv6.h
tcpdump.o: dstring.h
tcpdump.o: pool.h
tcptrace.o: tcptrace.h
tcptrace.o: ipv6.h
tcptrace.o: dstring.h
tcptrace.o: pool.h
tcptrace.o: file_formats.h
tcptrace.o: modules.h
tcptrace.o: version.h
thruput.o: tcptrace.h
thruput.o: ipv6.h
thruput.o: dstring.h
thruput.o: pool.h
trace.o: tcptrace.h
trace.o: ipv6.h
trace.o: dstring.h
trace.o: pool.h
trace.o: gcache.h
udp.o: tcptrace.h
udp.o: ipv6.h
udp.o: dstring.h
udp.o: pool.h
udp.o: gcache.h
versnum.o: version.h
