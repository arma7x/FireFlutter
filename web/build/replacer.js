'use strict'

const fs = require('fs')

module.exports = function(filePath, content) {
  fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
      return console.log(err);
    }
    fs.writeFile(filePath, content, 'utf8', (err) => {
      if (err) return console.log(err);
    });
  });
}
