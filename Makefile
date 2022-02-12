# Configure luarocks to use luajit-openresty
#
# Example for MacOS:
#     brew install luajit-openresty
#     luarocks config --local lua_dir /opt/homebrew/opt/luajit-openresty
#
# This will configure luarocks using 5.1 to use luajit-openresty.
LUA_VERSION=5.1

LUA_PATH = deps/share/lua/$(LUA_VERSION)/?.lua;deps/share/lua/$(LUA_VERSION)/?/init.lua
LUA_PATH += ;lua/?.lua;lua/?/init.lua
export LUA_PATH

export LUA_CPATH = deps/lib/lua/$(LUA_VERSION)/?.so

ifdef PCRE_DIR
LREXLIB_PCRE_FLAGS = PCRE_DIR=$(PCRE_DIR)
endif
# Example for MacOS installed via Homebrew:
# PCRE_DIR = /opt/homebrew/Cellar/pcre/8.45

LUAROCKS = luarocks --lua-version=$(LUA_VERSION) --tree=deps

deps:
	$(LUAROCKS) install lrexlib-pcre $(LREXLIB_PCRE_FLAGS)
	$(LUAROCKS) install inspect
	$(LUAROCKS) install net-url
	$(LUAROCKS) install jsonschema

.PHONY: test
test: deps
	./scripts/packspec.lua examples/packspec.1.lua

.PHONY: clean
clean:
	$(RM) -rf deps
