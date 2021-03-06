##############################################################
#
# This file includes all the test targets as well as all the
# non-default build rules and test recipes.
#
##############################################################
TESTDIR := ./tests/

# ASTYLE := $(shell which astyle)
# ifeq ($(ASTYLE),)
# $(info command <astyle> not found! )
# $(info Install it to get advantage of automatic code formatting.)
# $(info After installation, run <make format> to format all the files to)
# $(info allman style code formatting.)
# endif

##############################################################
#
# Test targets
#
##############################################################

###### Place all generic definitions here ######

# This defines tests which run tools of the same name.  This is simply for convenience to avoid
# defining the test name twice (once in TOOL_ROOTS and again in TEST_ROOTS).
# Tests defined here should not be defined in TOOL_ROOTS and TEST_ROOTS.
TEST_TOOL_ROOTS :=

# This defines the tests to be run that were not already defined in TEST_TOOL_ROOTS.
TEST_ROOTS :=

# This defines a list of tests that should run in the "short" sanity. Tests in this list must also
# appear either in the TEST_TOOL_ROOTS or the TEST_ROOTS list.
# If the entire directory should be tested in sanity, assign TEST_TOOL_ROOTS and TEST_ROOTS to the
# SANITY_SUBSET variable in the tests section below (see example in makefile.rules.tmpl).
SANITY_SUBSET :=

# This defines the tools which will be run during the the tests, and were not already defined in
# TEST_TOOL_ROOTS.
TOOL_ROOTS := mcprof

# This defines the static analysis tools which will be run during the the tests. They should not
# be defined in TEST_TOOL_ROOTS. If a test with the same name exists, it should be defined in
# TEST_ROOTS.
# Note: Static analysis tools are in fact executables linked with the Pin Static Analysis Library.
# This library provides a subset of the Pin APIs which allows the tool to perform static analysis
# of an application or dll. Pin itself is not used when this tool runs.
SA_TOOL_ROOTS :=

# This defines all the applications that will be run during the tests.
APP_ROOTS := vectOps memAllocFree memAllocFreeWrappers memSetCopyMove \
	multiAllocFtn multiAllocMacro multiAllocClass loopAllocations \
	memNewDelete vectOpsCPP01 vectOpsCPP02 vectOpsCPP03 vectOpsCPP04 \
	markers loopDepend callGraph allocDepend virtualFunction aepeTest

# This defines any additional object files that need to be compiled.
OBJECT_ROOTS :=

# This defines any additional dlls (shared objects), other than the pintools, that need to be compiled.
DLL_ROOTS :=

# This defines any static libraries (archives), that need to be built.
LIB_ROOTS :=


###### Place OS-specific definitions here ######
# Android
ifeq ($(TARGET_OS),android)
endif

# Linux
# -O2 -g -fno-inline -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wfatal-errors
ifeq ($(TARGET_OS),linux)
    #TOOL_CXXFLAGS+= -MD -std=c++11 -I. -Wfatal-errors #-fexceptions
    TOOL_CXXFLAGS+= -MD -std=c++0x -I. -Wfatal-errors
    #TOOL_LDFLAGS+= -pg
    #TOOL_LIBS+= -lelf # not needed as with after Pin 3 we cannot link gnu libelf!
    APP_CXXFLAGS:=$(filter-out -O3,$(APP_CXXFLAGS))
    APP_CCFLAGS:=$(filter-out -O3,$(APP_CCFLAGS))
    APP_CXXFLAGS+= -O2 -g -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wfatal-errors
    APP_CCFLAGS+= -O2 -g -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wfatal-errors
endif

# Windows
ifeq ($(TARGET_OS),windows)
endif

##############################################################
#
# Test recipes
#
##############################################################
MCPROF_OPT:=-RecordStack 0 -TrackObjects 1 -Engine 1
# This section contains recipes for tests other than the default.
# See makefile.default.rules for the default test rules.
# All tests in this section should adhere to the naming convention: <testname>.test

vectOps.test: $(OBJDIR)vectOps$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) -RecordStack 0 -TrackObjects 1 -Engine 1 -- $(OBJDIR)vectOps$(EXE_SUFFIX)

memAllocFree.test: $(OBJDIR)memAllocFree$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)memAllocFree$(EXE_SUFFIX)

memAllocFreeWrappers.test: $(OBJDIR)memAllocFreeWrappers$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)memAllocFreeWrappers$(EXE_SUFFIX)

memNewDelete.test: $(OBJDIR)memNewDelete$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)memNewDelete$(EXE_SUFFIX)

vectOpsCPP01.test: $(OBJDIR)vectOpsCPP01$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)vectOpsCPP01$(EXE_SUFFIX)

vectOpsCPP02.test: $(OBJDIR)vectOpsCPP02$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)vectOpsCPP02$(EXE_SUFFIX)

vectOpsCPP03.test: $(OBJDIR)vectOpsCPP03$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)vectOpsCPP03$(EXE_SUFFIX)

vectOpsCPP04.test: $(OBJDIR)vectOpsCPP04$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)vectOpsCPP04$(EXE_SUFFIX)

memSetCopyMove.test: $(OBJDIR)memSetCopyMove$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)memSetCopyMove$(EXE_SUFFIX)

multiAllocFtn.test: $(OBJDIR)multiAllocFtn$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)multiAllocFtn$(EXE_SUFFIX)

loopAllocations.test: $(OBJDIR)loopAllocations$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)loopAllocations$(EXE_SUFFIX)

multiAllocMacro.test: $(OBJDIR)multiAllocMacro$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)multiAllocMacro$(EXE_SUFFIX)

multiAllocClass.test: $(OBJDIR)multiAllocClass$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -- $(OBJDIR)multiAllocClass$(EXE_SUFFIX)

markers.test: $(OBJDIR)markers$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) $(MCPROF_OPT) -TrackZones 1 -TrackStartStop 1 -- $(OBJDIR)markers$(EXE_SUFFIX)

callGraph.test: $(OBJDIR)callGraph$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) -RecordStack 0 -TrackObjects 1 -Engine 1 -- $(OBJDIR)callGraph$(EXE_SUFFIX)
	@python -m json.tool callgraph.json > temp
	@mv temp callgraph.json

virtualFunction.test: $(OBJDIR)virtualFunction$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) -RecordStack 0 -TrackObjects 1 -Engine 1 -- $(OBJDIR)virtualFunction$(EXE_SUFFIX)
	@python -m json.tool callgraph.json > temp
	@mv temp callgraph.json

loopDepend.test: $(OBJDIR)loopDepend$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) -RecordStack 0 -TrackObjects 0 -TrackLoopDepend 1 -SelectedLoopNo 2 -- $(OBJDIR)loopDepend$(EXE_SUFFIX)

allocDepend.test: $(OBJDIR)allocDepend$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) -RecordStack 0 -TrackObjects 1 -Engine 1 -- $(OBJDIR)allocDepend$(EXE_SUFFIX)

aepeTest.test: $(OBJDIR)aepeTest$(EXE_SUFFIX)
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) -RecordStack 0 -TrackObjects 1 -Engine 1 -- $(OBJDIR)aepeTest$(EXE_SUFFIX)

##############################################################
#
# Build rules
#
##############################################################
# This section contains the build rules for all binaries that have special build rules.
# See makefile.default.rules for the default build rules.

CPPSRCS =	globals.cpp shadow.cpp callstack.cpp commatrix.cpp \
		symbols.cpp counters.cpp json.cpp \
		engine1.cpp engine2.cpp engine3.cpp \
		pintrace.cpp mcprof.cpp
CPPOBJS = $(CPPSRCS:%.cpp=$(OBJDIR)%$(OBJ_SUFFIX))

$(OBJDIR)mcprof$(PINTOOL_SUFFIX): $(CPPOBJS)
	$(LINKER) $(TOOL_LDFLAGS) $(LINK_EXE)$@ $^ $(TOOL_LPATHS) $(TOOL_LIBS)

-include $(OBJDIR)*.d

clean: cleantemp
cleantemp:
	rm -f *~ $(TESTDIR)*~ *.dat *.dot *.json *.pdf *.eps

###### Special applications' build rules ######
$(OBJDIR)%$(EXE_SUFFIX): $(TESTDIR)%.c
	$(APP_CC) -I. $(APP_CCFLAGS) $(COMP_EXE)$@ $^ $(APP_LDFLAGS) $(APP_LIBS)

$(OBJDIR)%$(EXE_SUFFIX): $(TESTDIR)%.cpp
	$(APP_CXX) -I. $(APP_CXXFLAGS) $(COMP_EXE)$@ $^ $(APP_LDFLAGS) $(APP_LIBS)

$(OBJDIR)memAllocFreeWrappers$(EXE_SUFFIX): $(TESTDIR)memAllocFreeWrappers.c $(OBJDIR)malloc_wrap.o
	$(APP_CC) -I. -fno-inline -O1 -g $(COMP_EXE)$@ $^ $(APP_LDFLAGS) $(APP_LIBS)

$(OBJDIR)malloc_wrap.o: $(TESTDIR)malloc_wrap.c
	$(APP_CC) -I. -fno-inline -O1 -g -c $^ -o $@

help: $(OBJDIR)mcprof$(PINTOOL_SUFFIX)
# 	|| true is just to supress the return of non zero value
	$(PIN) -t $(OBJDIR)mcprof$(PINTOOL_SUFFIX) -h -- ls || true

format:
	astyle --style=allman *.h *.cpp
# 	astyle --style=kr *.h *.cpp
	rm -f *.orig

openingFileOrder=makefile.rules globals.h globals.cpp markers.h \
	shadow.h shadow.cpp commatrix.h commatrix.cpp \
	symbols.h symbols.cpp \
	counters.h counters.cpp \
	callstack.h callstack.cpp json.h json.cpp callgraph.h \
	engine1.h engine1.cpp engine2.h engine2.cpp engine3.h engine3.cpp \
	pintrace.h pintrace.cpp \
	mcprof.cpp
open:
	kate -n $(openingFileOrder) &> /dev/null &
vimopen:
	vim $(openingFileOrder)

tarball:
	make clean
	cd ..; tar -czf mcprof.tar.gz  --exclude='mcprof/doc/latex' --exclude='mcprof/.git*' mcprof
	mv ../mcprof.tar.gz ~/Desktop/.
