# Makefile for serving local files using Python's http.server
# Assumes index.html (and other assets) already exist in this directory.

# --- Configuration ---
# Default port for the server
PORT ?= 8000
# Python executable (change if needed, e.g., python3)
PYTHON ?= python

# --- Targets ---

# Default target: run the server
.DEFAULT_GOAL := serve

# Phony targets are actions, not files
.PHONY: serve help

# Target to start the HTTP server
serve: ## Start the Python HTTP server on http://localhost:$(PORT)
	@echo "Starting server on port $(PORT)... Press Ctrl+C to stop."
	@echo "Serving files from directory: $(CURDIR)"
	@echo "Access URL: http://localhost:$(PORT)"
	$(PYTHON) -m http.server $(PORT)

# Target to display help information
help: ## Show this help message
	@echo "Usage: make [TARGET] [VARIABLE=VALUE]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables:"
	@echo "  PORT=xxxx       Specify the port number (default: $(PORT))"
	@echo "  PYTHON=python   Specify the python executable (default: $(PYTHON))"
	@echo ""
	@echo "Example:"
	@echo "  make serve PORT=9000"
