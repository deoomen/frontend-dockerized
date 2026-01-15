#!/bin/sh

# Framework-based port configuration
# This script detects the framework and sets appropriate ports

detect_framework_and_port() {
    if [ -f "package.json" ]; then
        # Default ports for each framework
        if grep -q '"next"' package.json; then
            echo "next:3000"
        elif grep -q '"expo"' package.json || grep -q '"@expo/' package.json; then
            echo "expo:8081"
        elif grep -q '"react"' package.json && ! grep -q '"next"' package.json; then
            echo "react:5173"
        elif grep -q '"vue"' package.json; then
            echo "vue:5173"
        elif grep -q '"vite"' package.json; then
            echo "vite:5173"
        elif grep -q '"fastify"' package.json; then
            echo "fastify:3000"
        else
            echo "unknown:8080"
        fi
    else
        echo "unknown:8080"
    fi
}

# Function to get just the port
get_framework_port() {
    result=$(detect_framework_and_port)
    echo "${result#*:}"
}

# Function to get just the framework
get_framework_name() {
    result=$(detect_framework_and_port)
    echo "${result%:*}"
}
