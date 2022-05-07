#!/bin/bash
sayHello(){
	echo "Hello World\n"
	exit
}
sayHi(){
	sayHello
	echo "Hello Issam"
}
sayHi
