-- Copyright (c) 2015 — 2016, Aapo Talvensaari
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice, this
--   list of conditions and the following disclaimer.
--
-- * Redistributions in binary form must reproduce the above copyright notice,
--   this list of conditions and the following disclaimer in the documentation
--   and/or other materials provided with the distribution.
--
-- * Neither the name of lua-resty-prettycjson nor the names of its
--   contributors may be used to endorse or promote products derived from
--   this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
-- CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
-- OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
-- OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

local enc = vim.json.encode
local cat = table.concat
local sub = string.sub
local rep = string.rep
return function(dt, lf, id, ac, ec)
    local s, e = (ec or enc)(dt)
    if not s then return s, e end
    lf, id, ac = lf or "\n", id or "\t", ac or " "
    local i, j, k, n, r, p, q  = 1, 0, 0, #s, {}, nil, nil
    local al = sub(ac, -1) == "\n"
    for x = 1, n do
        local c = sub(s, x, x)
        if not q and (c == "{" or c == "[") then
            r[i] = p == ":" and cat{ c, lf } or cat{ rep(id, j), c, lf }
            j = j + 1
        elseif not q and (c == "}" or c == "]") then
            j = j - 1
            if p == "{" or p == "[" then
                i = i - 1
                r[i] = cat{ rep(id, j), p, c }
            else
                r[i] = cat{ lf, rep(id, j), c }
            end
        elseif not q and c == "," then
            r[i] = cat{ c, lf }
            k = -1
        elseif not q and c == ":" then
            r[i] = cat{ c, ac }
            if al then
                i = i + 1
                r[i] = rep(id, j)
            end
        else
            if c == '"' and p ~= "\\" then
                q = not q and true or nil
            end
            if j ~= k then
                r[i] = rep(id, j)
                i, k = i + 1, j
            end
            r[i] = c
        end
        p, i = c, i + 1
    end
    return cat(r)
end
