chai = require 'chai'

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
        MyEnumSecond,
        MyEnumThird
    };

    static const char *MyEnum_names[] = {
        "First",
        "Second",
        "Third",
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
    describe 'declared in .cpp comment', () ->
        it 'should generate enum and names', (done) ->
            run 'inline.cpp', (err, result) ->
                chai.expect(err).to.be.a 'null'
                chai.expect(result).to.equal expected
                done()

