# Keep all tool caches inside the project .cache/ directory.
# Run this before builds: source setenv.sh
if command -v cygpath >/dev/null 2>&1; then
  ECOBLOCKS_ROOT="$(cygpath -m "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
else
  ECOBLOCKS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

export GRADLE_USER_HOME="$ECOBLOCKS_ROOT/.cache/gradle"
export PUB_CACHE="$ECOBLOCKS_ROOT/.cache/pub"
export npm_config_cache="$ECOBLOCKS_ROOT/.cache/npm"

echo "EcoBlocks: tool caches -> $ECOBLOCKS_ROOT/.cache"
