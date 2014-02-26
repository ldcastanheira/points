TARGET=libcli.a

CFLAGS+=-Wall -g -Werror

SOURCES=$(wildcard *.c)
OBJECTS?=$(SOURCES:.c=.o)

all: $(OBJECTS) $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $^

$(TARGET): $(OBJECTS)
	$(AR) cr $@ $^

clean:
	rm $(OBJECTS) $(TARGET)

