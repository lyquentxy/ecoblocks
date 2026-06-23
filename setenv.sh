# 本项目所有工具缓存指向项目内 .cache/ 目录。C 盘不碰。
# 每次打开终端先 source 这个文件。

if command -v cygpath >/dev/null 2>&1; then
  ECOBLOCKS_ROOT="$(cygpath -m "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
else
  ECOBLOCKS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

export GRADLE_USER_HOME="$ECOBLOCKS_ROOT/.cache/gradle"
export PUB_CACHE="$ECOBLOCKS_ROOT/.cache/pub"
export npm_config_cache="$ECOBLOCKS_ROOT/.cache/npm"

echo "EcoBlocks: 所有缓存指向 $ECOBLOCKS_ROOT/.cache"
