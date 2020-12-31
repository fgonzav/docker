#!/bin/sh

cd /opt/app || exit

JAR="zipkin.jar"

java -jar "$JAR"
