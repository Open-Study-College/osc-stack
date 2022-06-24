const fs = require('fs')
var mv = require('mv')
var path = require('path')

var oldPath =  path.join(process.cwd(), '/migrations')
var newPath = path.join(process.cwd(), '/prisma/migrations')

try {
    fs.readFile(path.join(process.cwd(), '/prisma/schema.prisma'), 'utf8', function (err,data) {
        if (err) {
            return console.log(err);
        }
        var result = data.replace(/sqlite/g, 'mysql');

        fs.writeFile(path.join(process.cwd(), '/prisma/schema.prisma'), result, 'utf8', function (err) {
            if (err) return console.log(err);
        });
    });

  if (fs.existsSync(oldPath)) {
        fs.rmSync(path.join(process.cwd(), '/prisma/migrations'), { recursive: true, force: true });

        mv(oldPath, newPath, function (err) {
        if (err) throw err
        console.log('Successfully renamed - AKA moved!')
        })
  }
} catch(err) {
  console.error(err)
}