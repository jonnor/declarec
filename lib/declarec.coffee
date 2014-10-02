

generateEnum = (name, prefix, enums) ->
    if Object.keys(enums).length == 0
        return ""
    indent = "\n    "

    out = "enum " + name + " {";
    a = []
    for e, val of enums
        v = if (val != null) then " = " + val else ""
        a.push (indent + prefix + e + v)
    out += a.join ","
    out += "\n};\n"

    return out


### TODO: implement initial value generation?
generateInitial = (name, def) ->
    return 'const FinitoStateId ' + name + " = " + nameToId(def.initial.state, def.states) + ";\n"
###

generateStringMap = (mapname, values) ->
    indent = "    "
    r = "static const char *#{mapname}[] = {\n"
    for name, val of values
        r += indent+"\"#{name}\",\n"
    r.trim ","

    r+= "};\n"
    return r

###
TODO: implement namespaced collection of definitions?
generateDefinition = (name, def) ->
    indent = "   "
    r = "FinitoDefinition #{name}_def = {\n"
    initial = nameToId(def.initial.state, def.states)
    r += indent+"#{initial}, #{name}_run, #{name}_statenames\n"
    r += "};\n"
    return r
###

startsWith = (str, sub) ->
    return (str.indexOf(sub) == 0)



extractDef = (content, marker, lang) ->
    lang = 'c' if not lang
    marker = 'declarec' if not marker

    isStart = (line) -> false
    isEnd = (line) -> false
    if lang is 'c'
        isStart = (line) -> startsWith line, "/* #{marker}"
        isEnd = (line) -> startsWith line, "#{marker} */"
    
    definitions = []
    startIdx = null
    endIdx = null
    lines = content.split '\n'
    lines.forEach (line, idx) ->

        if startIdx == null
            # Look for start
            startIdx = idx if isStart line
        if endIdx == null
            # Look for end
            endIdx = idx if isEnd line
        if startIdx != null and endIdx != null
            # Definition section complete
            startLine = lines[startIdx]
            tok = startLine.split ' '
            l = lines.splice startIdx+1, endIdx-2
            d =
                marker: tok[1]
                content: l.join '\n'
            # Optional
            d.format = tok[2] if tok.length > 1
            d.target = tok[3] if tok.length > 2 
            definitions.push d
            startIdx = null
            endIdx = null

    return definitions

main = () ->

    fs = require 'fs'
    path = require 'path'
    yaml = require 'yaml'

    filename = process.argv[2]
    ext = path.extname filename
    contents = fs.readFileSync filename, {'encoding': 'utf8'}

    defs = null
    if ext == '.json'
        defs = JSON.parse contents
    else if ext in ['.cpp', '.c']
        defs = extractDef contents, null, 'c'
        defs = (JSON.parse d.content for d in defs)
    else if ext in ['.yml', '.yaml']
        defs = yaml.eval contents

    for def in defs
        console.log generateEnum def.name, def.name, def.values
        console.log generateStringMap def.name+'_names', def.values

exports.main = main
exports.extractDefinition = extractDef
