#!/bin/bash
set  -xe

while [ 'true' ]; do
ffplay -f lavfi -i "sine=frequency=174:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=285:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=396:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=417:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=528:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=639:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=741:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=852:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=963:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=852:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=741:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=639:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=528:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=417:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=396:duration=9"  -autoexit -nodisp
ffplay -f lavfi -i "sine=frequency=285:duration=9"  -autoexit -nodisp
done
