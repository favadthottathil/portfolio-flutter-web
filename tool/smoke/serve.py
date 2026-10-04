"""Static server for the smoke test.

Sends the same cross-origin-isolation headers as production (vercel.json),
which the multi-threaded Wasm renderer needs for SharedArrayBuffer.

    python3 serve.py PORT DIRECTORY
"""

import functools
import http.server
import sys


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "credentialless")
        super().end_headers()

    def log_message(self, *args):
        pass


if __name__ == "__main__":
    port, directory = int(sys.argv[1]), sys.argv[2]
    handler = functools.partial(Handler, directory=directory)
    http.server.ThreadingHTTPServer(("127.0.0.1", port), handler).serve_forever()
