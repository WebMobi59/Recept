var grunt = require('grunt');
module.exports = {
    localhostCertificate: {
        options: {
            port: 7000,
            base:  '<%= config.dir.localhostCertificate %>',
            protocol: 'http'
        }
    },
    debug: {
        options: {
            port: 8000,
            base:  '<%= config.dir.debug %>',
            protocol: 'https',
            key: grunt.file.read('certificates/server/self-signed-server.key.pem').toString(),
            cert: grunt.file.read('certificates/server/self-signed-server.crt.pem').toString(),
            ca: grunt.file.read('certificates/server/self-signed-root-ca.crt.pem').toString(),
            keepalive: true
        }
    },
    dev: {
        options: {
            port: 8000,
            base:  '<%= config.dir.dev %>',
            protocol: 'https',
            key: grunt.file.read('certificates/server/self-signed-server.key.pem').toString(),
            cert: grunt.file.read('certificates/server/self-signed-server.crt.pem').toString(),
            ca: grunt.file.read('certificates/server/self-signed-root-ca.crt.pem').toString(),
            keepalive: true
        }
    },
    test: {
        options: {
            port: 8000,
            base:  '<%= config.dir.test %>',
            protocol: 'https',
            key: grunt.file.read('certificates/server/self-signed-server.key.pem').toString(),
            cert: grunt.file.read('certificates/server/self-signed-server.crt.pem').toString(),
            ca: grunt.file.read('certificates/server/self-signed-root-ca.crt.pem').toString(),
            keepalive: true
        }
    },
    production: {
        options: {
            port: 8000,
            base:  '<%= config.dir.production %>',
            protocol: 'https',
            key: grunt.file.read('certificates/server/self-signed-server.key.pem').toString(),
            cert: grunt.file.read('certificates/server/self-signed-server.crt.pem').toString(),
            ca: grunt.file.read('certificates/server/self-signed-root-ca.crt.pem').toString(),
            keepalive: true
        }
    }
};
