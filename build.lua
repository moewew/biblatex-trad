#!/usr/bin/env texlua

-- Build script for "biblatex-trad" files

-- Identify the bundle and module
module = "biblatex-trad"

unpackfiles = { }

-- Install biblatex style files and use these as the sources
installfiles = {"*.cbx", "*.bbx"}
sourcefiles  = installfiles

checkengines = {"pdftex"}
checkruns    = 3

function runtest_tasks(name)
  return "biber -q " .. name
end

-- Release a TDS-style zip
packtdszip  = true


tagfiles = {"*.bbx", "*.cbx", "*.def", "*.tex", "*.md", "*.sty"}

function update_tag(file, content, tagname, tagdate)
  local isodatescheme = "%d%d%d%d%-%d%d%-%d%d"
  local ltxdatescheme = string.gsub(isodatescheme, "%-", "/")
  local versionscheme = "%d+%.%d+%.?%d?%w?"
  local latexdate = string.gsub(tagdate, "%-", "/")
  local tagyear = string.match(tagdate, "%d%d%d%d")
  local safetagname = string.gsub(tagname, "^v", "")
  if string.match(file, "%.bbx$")  or string.match(file, "%.cbx$") then
    return string.gsub(content , ltxdatescheme .. " v" .. versionscheme,
                                 latexdate .. " v" .. safetagname)
  elseif string.match(file, "%.tex$") then
    content = string.gsub(content, "revision%s*=%s*{" .. versionscheme .. "}",
                                   "revision={" .. safetagname .."}")
    content = string.gsub(content, "date%s*=%s*{\\DTMDate{" .. isodatescheme ..
                                     "}}",
                                   "date={\\DTMDate{" .. tagdate .."}}")
    content = string.gsub(content ,"\n\\begin{release}{<version>}{<date>}\n",
                                   "\n\\begin{release}{" .. safetagname .. "}{"
                                     .. tagdate .."}\n")
    return string.gsub(content, "2016%-%-%d%d%d%d Moritz Wemheuer",
                                "2016--" .. tagyear .. " Moritz Wemheuer")
  elseif string.match(file, "^README%.md$") then
    return string.gsub(content, "Copyright 2017%-%d%d%d%d",
                                "Copyright 2017-" .. tagyear)
  elseif string.match(file, "^CHANGES%.md$") then
    content = string.gsub(content, "2016 %-%- %d%d%d%d Moritz Wemheuer",
                                   "2016 -- " .. tagyear .. " Moritz Wemheuer")
    return content
  end
  return content
end

kpse.set_program_name ("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end
