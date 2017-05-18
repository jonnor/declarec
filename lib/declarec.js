var declarec = null;
try {
    declarec = require('../dist/declarec.js');
} catch (e) {
    declarec = e;
}

if (declarec.message) {
    console.log('declarec: Error loading built module', declarec.message);
    console.log('declarec: Loading from source');
    require('coffee-script/register');
    declarec = require('./declarec.coffee');
}

module.exports = declarec;
