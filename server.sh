#!/bin/bash

# Define the port
PORT=9000

# Switch to the web construction directory
cd /app/build/web/

# Start the web server on the specified port
echo "Starting the server on port $PORT..."
python3 -m http.server $PORT