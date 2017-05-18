chai = require 'chai'
declarec = require '../'

run = (example, callback) ->
    child_process = require 'child_process'
    path = require 'path'

    exec = path.join __dirname, '../bin/declarec'
    file = path.join __dirname, '../examples', example
    cmd = "#{exec} #{file}"
    child_process.exec cmd, (err, stdout, stderr) ->
        return callback err, stdout

describe 'Hello World example', () ->
    expected =
    """
    enum MyEnum {
        MyEnumFirst = 0,
        MyEnumSecond = 1,
        MyEnumThird = 2
    };

    static const char *MyEnum_names[] = {
        "First",
        "Second",
        "Third"
    };


    """

    describe 'declared in .json', () ->
        it 'should generate enum and names', (done) ->
            run 'defs.json', (err, result) ->
                chai.expect(err).to.be.a 'null'
                chai.expect(result).to.equal expected
                done()
    describe 'declared in .yml', () ->
        it 'should generate enum and names', (done) ->
            run 'defs.yml', (err, result) ->
                chai.expect(err).to.be.a 'null'
                chai.expect(result).to.equal expected
                done()
    describe 'json declared in .cpp comment', () ->
        it 'should generate enum and names', (done) ->
            run 'inline.cpp', (err, result) ->
                chai.expect(err).to.be.a 'null'
                chai.expect(result).to.equal expected
                done()
        it 'should extract filename', (done) ->
            p = require('path').join __dirname, '../examples/', 'inline.cpp'
            declarec.definitionsFromFile p, (err, defs) ->
                chai.expect(err).to.be.a 'null'
                chai.expect(defs[0].target).to.equal 'mydefs.h'
                done()
    describe 'yaml declared in .cpp comment', () ->
        it 'should generate enum and names', (done) ->
            run 'inline-yaml.cpp', (err, result) ->
                chai.expect(err).to.be.a 'null'
                chai.expect(result).to.equal expected
                done()
        it 'should extract filename', (done) ->
            p = require('path').join __dirname, '../examples/', 'inline-yaml.cpp'
            declarec.definitionsFromFile p, (err, defs) ->
                chai.expect(err).to.be.a 'null'
                chai.expect(defs[0].target).to.equal 'mydefsyaml.h'
                done()
