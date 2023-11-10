CC = g++
CXXFLAGS := $(shell pkg-config --cflags rtmidi)
LDFLAGS := $(shell pkg-config --libs rtmidi)
TARGET = main

SRC_FILES := $(wildcard *.cpp)
OBJ_FILES := $(patsubst %.cpp,%.o,$(SRC_FILES))

all: $(TARGET)

$(TARGET): $(OBJ_FILES)
	echo $(LDFLAGS)
	$(CC) $(CXXFLAGS)  $^ -o $@  $(LDFLAGS)

%.o: %.cpp
	$(CC) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ_FILES) $(TARGET)
