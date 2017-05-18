var declarec = null;
try {
    declarec = require('../dist/declarec.js');
} catch (e) {
    console.log('declarec: Could not load built module, loading from source');
    require('coffee-script/register');
    declarec = require('./declarec.coffee');
}
module.exports = declarec;
