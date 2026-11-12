#!/usr/bin/env python3
"""Zero-cost local mock HTTP server to satisfy `kit check` model API probes offline."""

import json
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer


class MockHandler(BaseHTTPRequestHandler):
  def do_GET(self):
    self.send_response(200)
    self.send_header("Content-Type", "application/json")
    self.end_headers()
    self.wfile.write(b'{"status": "ok"}')

  def do_POST(self):
    self.send_response(200)
    self.send_header("Content-Type", "application/json")
    self.end_headers()
    response = {
        "id": "mock-completion",
        "object": "chat.completion",
        "choices": [{
            "index": 0,
            "message": {
                "role": "assistant",
                "content": "OK",
            },
            "finish_reason": "stop",
        }],
    }
    self.wfile.write(json.dumps(response).encode("utf-8"))

  def log_message(self, format, *args):
    # Suppress request logging
    pass


def main():
  port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
  server = HTTPServer(("127.0.0.1", port), MockHandler)
  try:
    server.serve_forever()
  except KeyboardInterrupt:
    pass
  finally:
    server.server_close()


if __name__ == "__main__":
  main()
