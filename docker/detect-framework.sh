#!/bin/bash

# Smart port detection for Make commands
# This script detects the framework and exports appropriate environment variables

PROJECT_DIR="${1:-.}"

if [ -f "$PROJECT_DIR/package.json" ]; then
    # Detect framework and get port
    if grep -q '"next"' "$PROJECT_DIR/package.json"; then
        FRAMEWORK="next"
        DETECTED_PORT="3000"
    elif grep -q '"expo"' "$PROJECT_DIR/package.json" || grep -q '"@expo/' "$PROJECT_DIR/package.json"; then
        FRAMEWORK="expo"
        DETECTED_PORT="8081"
    elif grep -q '"react"' "$PROJECT_DIR/package.json" && ! grep -q '"next"' "$PROJECT_DIR/package.json"; then
        FRAMEWORK="react"
        DETECTED_PORT="5173"
    elif grep -q '"vue"' "$PROJECT_DIR/package.json"; then
        FRAMEWORK="vue"
        DETECTED_PORT="5173"
    elif grep -q '"vite"' "$PROJECT_DIR/package.json"; then
        FRAMEWORK="vite"
        DETECTED_PORT="5173"
    elif grep -q '"fastify"' "$PROJECT_DIR/package.json"; then
        FRAMEWORK="fastify"
        DETECTED_PORT="3000"
    else
        FRAMEWORK="unknown"
        DETECTED_PORT="8080"
    fi
else
    FRAMEWORK="none"
    DETECTED_PORT="8080"
fi

echo "DETECTED_FRAMEWORK=$FRAMEWORK"
echo "DETECTED_PORT=$DETECTED_PORT"
