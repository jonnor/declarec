

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

extractDef = (content) ->
    
    definitions = []
    startIdx = null
    endIdx = null
    lines = content.split '\n'
    lines.forEach (line, idx) ->

        if startIdx == null
            # Look for start
            if startsWith line, '/* declarec'
                startIdx = idx
        if endIdx == null
            # Look for end
            if startsWith line, 'declarec */'
                endIdx = idx

        if startIdx != null and endIdx != null
            l = lines.splice startIdx+1, endIdx-2
            d = JSON.parse l.join '\n'
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

    defs = null
    if ext == '.json'
        defs = JSON.parse fs.readFileSync filename
    else if ext in ['.cpp', '.c']
        defs = extractDef fs.readFileSync filename, {'encoding': 'utf8'}
    else if ext in ['.yml', '.yaml']
        defs = yaml.eval fs.readFileSync filename, {'encoding': 'utf8'}

    for def in defs
        console.log generateEnum def.name, def.name, def.values
        console.log generateStringMap def.name+'_names', def.values

exports.main = main

