const { mkdir } = require('fs')
var mv = require('mv')
var path = require('path')
const fs = require('fs')

  var oldPath =  path.join(process.cwd(), '/prisma/migrations')
  var newPath = path.join(process.cwd(), '/migrations')

try {

        fs.readFile(path.join(process.cwd(), '/prisma/schema.prisma'), 'utf8', function (err,data) {
            if (err) {
                return console.log(err);
            }
            var result = data.replace(/mysql/g, 'sqlite');

            fs.writeFile(path.join(process.cwd(), '/prisma/schema.prisma'), result, 'utf8', function (err) {
                if (err) return console.log(err);
            });
        });


  if (fs.existsSync(oldPath)) {

        mkdir(path.join(process.cwd(), 'migrations'), () => {})

        mv(oldPath, newPath, function (err) {
        if (err) throw err
        console.log('Successfully renamed - AKA moved!')
        })
  }
} catch(err) {
  console.error(err)
}