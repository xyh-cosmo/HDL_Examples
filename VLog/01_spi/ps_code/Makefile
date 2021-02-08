#   ============================================================================
#   Youhua Xu Dec-13-2017
#   ============================================================================
#   Make a build dir for compilation
MDIR := $(shell pwd)
WRKDIR = $(MDIR)/build
BINDIR = $(MDIR)/bin
# DEBUG  = $(MDIR)/debug

#	make build & binary dirs
.base:
	if ! [ -e $(WRKDIR) ]; then mkdir $(WRKDIR) ; fi;
	touch $(WRKDIR)/.base;
	if ! [ -e $(BINDIR) ]; then mkdir $(BINDIR) ; fi;
	touch $(BINDIR)/.base;
	# if ! [ -e $(DEBUG) ]; then mkdir $(DEBUG) ; fi;
	# touch $(DEBUG)/.base;
#   ============================================================================
#   Set the source file path
vpath %.c   main:src:tests
vpath %.h   include
vpath %.o build
vpath .base build

INCLUDES = -I $(MDIR)/include

# CC			= arm-linux-gnueabihf-gcc
CC			= gcc
CCFLAG  	= -Wall
OPTFLAG		= #-O2 #-ffast-math #( not recognized by intel compiler )
LIBS		= -lm #-lgsl -lgslcblas 
LDFLAG      = 

#   http://www.tuicool.com/articles/NBfeYj
ifeq ($(shell uname -s),Linux)
	LDFLAG	+= -Wl,--no-as-needed
endif

ifeq ($(shell uname -s),Darwin)
	LDFLAG	+= -framework Accelerate #(-framework Accelerate is for Mac OSX)
endif

#%.o: %.cpp .base
#	cd $(WRKDIR);$(CPP) $(OMPFLAG) $(OPTFLAG) $(CCFLAG) $(INCLUDES) -c ../$< -o $*.o

# %.o: %.cc .base
# 	cd $(WRKDIR);$(CC) $(OMPFLAG) $(OPTFLAG) $(CCFLAG) $(INCLUDES) -c ../$< -o $*.o

%.o: %.c .base
	cd $(WRKDIR);$(CC) $(OMPFLAG) $(OPTFLAG) $(CCFLAG) $(INCLUDES) -c ../$< -o $*.o

MAIN_CCD231 = CCD231_main.o
MAIN_SPICFG = SPI_Config.o
MAIN_AD5628 = ConfigAD5628.o
MAIN_AD9106 = ConfigAD9106.o
MAIN_2271A	= ConfigLTC2271A.o
MAIN_2271B	= ConfigLTC2271B.o
MAIN_READ_BIN	= test_read_bin.o

DEPS	= common.o adc.o spi.o misc.o ad5628.o ad9106.o ad9106_config.o ltc2271.o

all: spi_cfg ad5628 ad9106 ltc2271-a ltc2271-b test_read_bin ccd231

ccd231: ${MAIN_CCD231} ${DEPS}
	${CC} ${OPTFLAG} ${LDFLAG} $(addprefix build/,$(notdir $^)) ${LIBS} -o $(BINDIR)/$@

spi_cfg: ${MAIN_SPICFG} ${DEPS}
	${CC} ${OPTFLAG} ${LDFLAG} $(addprefix build/,$(notdir $^)) ${LIBS} -o $(BINDIR)/$@

ad5628: ${MAIN_AD5628} ${DEPS}
	${CC} ${OPTFLAG} ${LDFLAG} $(addprefix build/,$(notdir $^)) ${LIBS} -o $(BINDIR)/$@

ad9106: ${MAIN_AD9106} ${DEPS}
	${CC} ${OPTFLAG} ${LDFLAG} $(addprefix build/,$(notdir $^)) ${LIBS} -o $(BINDIR)/$@

ltc2271-a: ${MAIN_2271A} ${DEPS}
	${CC} ${OPTFLAG} ${LDFLAG} $(addprefix build/,$(notdir $^)) ${LIBS} -o $(BINDIR)/$@

ltc2271-b: ${MAIN_2271B} ${DEPS}
	${CC} ${OPTFLAG} ${LDFLAG} $(addprefix build/,$(notdir $^)) ${LIBS} -o $(BINDIR)/$@

test_read_bin: ${MAIN_READ_BIN} ${DEPS}
	${CC} ${OPTFLAG} ${LDFLAG} $(addprefix build/,$(notdir $^)) ${LIBS} -o $(BINDIR)/$@

.PHONY:clean tidy run
clean: .base
	rm -rf $(WRKDIR);
tidy:
	make clean; rm -rf $(BINDIR) $(WRKDIR)
