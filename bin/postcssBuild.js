const path = require('path');
const fs = require('fs');
const transpileCss = require('./utils/helpers');
require('dotenv').config();

// build app/components
function fromDir(startPath, filter) {
    if (!fs.existsSync(startPath)) {
        console.log('no dir ', startPath);
        return;
    }

    var files = fs.readdirSync(startPath);
    for (var i = 0; i < files.length; i++) {
        var filename = path.join(startPath, files[i]);
        var stat = fs.lstatSync(filename);
        if (stat.isDirectory()) {
            fromDir(filename, filter); //recurse
        } else if (filename.endsWith(filter)) {
            console.log('-- found: ', filename);
            transpileCss(filename);
        }
    }
}

fromDir(path.join(process.cwd(), process.env.PATH_TO_COMPONENTS), '.scss');

// build main.scss
transpileCss(
    path.join(process.cwd(), process.env.PATH_TO_MAIN_SCSS),
    path.join(process.cwd(), process.env.PATH_TO_DEST_MAIN_CSS, '/main.css')
);
