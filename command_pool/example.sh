#!/bin/bash

# create a pool and store in var
TEMP=$(./command_pool.sh NEW)

# add commands to pool in a way we could see the order later
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'
./command_pool.sh ADD "$TEMP" curl 'https://www.random.org/strings/?num=1&len=10&digits=on&unique=on&format=plain&rnd=new'

# Run pool in 5 threads
./command_pool.sh RUN "$TEMP" 5