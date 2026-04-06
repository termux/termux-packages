
var path = process.argv[2],
    fs = require('fs'),
    yaml = require('../lib/yaml')
    
if (!path)
  throw new Error('provide path to yaml file')

fs.readFile(path, function(err, fileContents) {
  fileContents = fileContents.toString()
  console.log('\n')
  console.log(fileContents)
  console.log('\noutputs:\n')
  console.log(yaml.eval(fileContents))
})
