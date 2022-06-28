var path = require('path')
const fs = require('fs-extra');
require("dotenv").config()



const swapMigrationHistories = (prisma, sql) => {
  var prismaMigrations =  path.join(process.cwd(), prisma)
  var sqlMigrations = path.join(process.cwd(), sql)

function isEmpty(path) {
    return fs.readdirSync(path).length === 0;
}


try {
        // replace the string in schema.prisma
  if (isEmpty(prismaMigrations)) {
        fs.readFile(path.join(process.cwd(), '/prisma/schema.prisma'), 'utf8', function (err,data) {
            if (err) {
                return console.log(err);
            }
            var result = data.replace(/mysql/g, 'sqlite').replace(/PLANETSCALE_PRISMA_DATABASE_URL/g, 'SQLITE_DATABASE_URL').replace(/PRISMA_SHADOW_DATABASE_URL/g, 'SQLITE_SHADOW_DATABASE_URL')

            fs.writeFile(path.join(process.cwd(), '/prisma/schema.prisma'), result, 'utf8', function (err) {
                if (err) return console.log(err);
            });
        });
          } else if(isEmpty(sqlMigrations)) {
                    fs.readFile(path.join(process.cwd(), '/prisma/schema.prisma'), 'utf8', function (err,data) {
            if (err) {
                return console.log(err);
            }
            var result = data.replace(/sqlite/g, 'mysql').replace(/SQLITE_DATABASE_URL/g, 'PLANETSCALE_PRISMA_DATABASE_URL').replace(/SQLITE_SHADOW_DATABASE_URL/g, 'PRISMA_SHADOW_DATABASE_URL')

            fs.writeFile(path.join(process.cwd(), '/prisma/schema.prisma'), result, 'utf8', function (err) {
                if (err) return console.log(err);
            });
        });
          }
  function copyFolderSync(from, to) {
    if(!fs.existsSync(to)){
      fs.mkdirSync(to);
    }
      fs.readdirSync(from).forEach(element => {
          if (fs.lstatSync(path.join(from, element)).isFile()) {
              fs.copyFileSync(path.join(from, element), path.join(to, element));
          } else {
              copyFolderSync(path.join(from, element), path.join(to, element));
          }
      });
  }


        // move prisma migrations folder out
  if (isEmpty(prismaMigrations)) {
        fs.mkdirSync(prismaMigrations, { recursive: true})
        copyFolderSync(sqlMigrations, prismaMigrations, function (err) {
          if (err) throw err
          console.log('Successfully renamed - AKA moved mysql folder out of prisma!')
          }) 
          fs.rmSync(sqlMigrations, { recursive: true });
          fs.mkdirSync(sqlMigrations, { recursive: true})
  } else if(isEmpty(sqlMigrations)) {
        copyFolderSync(prismaMigrations, sqlMigrations, function (err) {
          if (err) throw err
          console.log('Successfully renamed - AKA moved migrations folder into prisma!')
          }) 
        fs.rmSync(prismaMigrations, { recursive: true, force: true });
        fs.mkdirSync(prismaMigrations, { recursive: true})
  }
  else {
    throw new Error('One or more migration histories missing')
  }
} catch(err) {
  console.error(err)
}
}


// at build, if sqlflag exists inside migrations, swap migration history
swapMigrationHistories(process.env.SQL_MIGRATION, process.env.PRISMA_MIGRATION)

