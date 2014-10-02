

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

main = () ->

    fs = require 'fs'

    filename = process.argv[2]
    console.log filename

    defs = JSON.parse fs.readFileSync filename
    for def in defs
        console.log generateEnum def.name, def.name, def.values

exports.main = main
