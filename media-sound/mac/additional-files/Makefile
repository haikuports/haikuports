VERSION	  = 4

CXXOPTS	  = -I Source/Shared -I Source/MACLib -DPLATFORM_LINUX -c
LDOPTS	  = -lstdc++

DLLLDOPTS = -shared
CMDLDOPTS = 

DLLNAME	  = libMAC.so.$(VERSION)
CMDNAME   = mac

#Set folders if not provided.
ifndef prefix
	prefix = /usr/local
endif

ifndef bindir
	bindir = $(prefix)/bin
endif

ifndef libdir
	libdir = $(prefix)/lib
endif

ifndef includedir
	includedir = $(prefix)/include
endif

SHAREDOBJECTS = Source/Shared/CharacterHelper.o Source/Shared/CircleBuffer.o Source/Shared/GlobalFunctions.o Source/Shared/StdLibFileIO.o Source/Shared/WinFileIO.o
LIBOBJECTS    = Source/MACLib/APECompress.o Source/MACLib/APECompressCore.o Source/MACLib/APECompressCreate.o Source/MACLib/APEDecompress.o Source/MACLib/APEHeader.o Source/MACLib/APEInfo.o Source/MACLib/APELink.o Source/MACLib/APESimple.o Source/MACLib/APETag.o Source/MACLib/BitArray.o Source/MACLib/MACLib.o Source/MACLib/MACProgressHelper.o Source/MACLib/MD5.o Source/MACLib/NewPredictor.o Source/MACLib/NNFilter.o Source/MACLib/Prepare.o Source/MACLib/UnBitArray.o Source/MACLib/UnBitArrayBase.o Source/MACLib/WAVInputSource.o Source/MACLib/Old/Anti-Predictor.o Source/MACLib/Old/AntiPredictorExtraHigh.o Source/MACLib/Old/AntiPredictorFast.o Source/MACLib/Old/AntiPredictorHigh.o Source/MACLib/Old/AntiPredictorNormal.o Source/MACLib/Old/APEDecompressCore.o Source/MACLib/Old/APEDecompressOld.o Source/MACLib/Old/UnBitArrayOld.o Source/MACLib/Old/UnMAC.o
DLLOBJECTS    = Source/MACDll/MACDll.o
CMDOBJECTS    = Source/Console/Console.o

all: $(DLLNAME) $(CMDNAME)

clean:
	rm -f $(DLLNAME) $(SHAREDOBJECTS) $(LIBOBJECTS) $(DLLOBJECTS) $(CMDNAME) $(CMDOBJECTS)

install:
	mkdir -p $(bindir)
	cp $(CMDNAME) $(bindir)

	mkdir -p $(libdir)
	cp $(DLLNAME) $(libdir)
	ln -sf $(DLLNAME) $(libdir)/libMAC.so

	mkdir -p $(includedir)/MAC
	cp Shared/*.h $(includedir)/MAC

$(DLLNAME): $(SHAREDOBJECTS) $(LIBOBJECTS) $(DLLOBJECTS)
	$(CXX) $(SHAREDOBJECTS) $(LIBOBJECTS) $(DLLOBJECTS) $(LDOPTS) $(LDFLAGS) $(DLLLDOPTS) -o $@

$(CMDNAME): $(DLLNAME) $(CMDOBJECTS)
	$(CXX) $(CMDOBJECTS) $(DLLNAME) $(LDOPTS) $(LDFLAGS) $(CMDLDOPTS) -o $@

Source/Shared/%.o: Source/Shared/%.cpp
	$(CXX) $(CXXOPTS) $(CXXFLAGS) $< -o $@

Source/MACLib/%.o: Source/MACLib/%.cpp
	$(CXX) $(CXXOPTS) $(CXXFLAGS) $< -o $@

Source/MACLib/Old/%.o: Source/MACLib/Old/%.cpp
	$(CXX) $(CXXOPTS) $(CXXFLAGS) $< -o $@

Source/MACDll/%.o: Source/MACDll/%.cpp
	$(CXX) $(CXXOPTS) $(CXXFLAGS) $< -o $@

Source/Console/%.o: Source/Console/%.cpp
	$(CXX) $(CXXOPTS) $(CXXFLAGS) $< -o $@
