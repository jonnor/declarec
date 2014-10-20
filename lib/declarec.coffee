

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

definitionsFromFile = (filename, callback) ->
    fs = require 'fs'
    path = require 'path'
    yaml = require 'yaml'

    ext = path.extname filename
    fs.readFile filename, {'encoding': 'utf8'}, (err, contents) ->
        return callback err, null if err
        defs = null
        if ext == '.json'
            defs = JSON.parse contents
        else if ext in ['.cpp', '.c']
            raw = extractDef contents, null, 'c'
            defs = ({} for r in raw)
            for idx in [0...raw.length]
                r = raw[idx]
                defs[idx] = JSON.parse r.content if r.format == 'json'
                defs[idx] = (yaml.eval r.content)[0] if r.format == 'yaml'
                defs[idx].target = raw[idx].target if raw[idx].target
                defs[idx].format = raw[idx].format if raw[idx].format
        else if ext in ['.yml', '.yaml']
            defs = yaml.eval contents
        return callback new Error "Unsupported file type #{ext}", defs if not defs
        return callback null, defs

main = () ->
    definitionsFromFile process.argv[2], (err, defs) ->
        for def in defs
            console.log generateEnum def.name, def.name, def.values
            console.log generateStringMap def.name+'_names', def.values

exports.main = main
exports.extractDefinition = extractDef
exports.definitionsFromFile = definitionsFromFile
exports.generateStringMap = generateStringMap
exports.generateEnum = generateEnum
