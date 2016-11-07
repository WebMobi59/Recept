module.exports = {
    localhostCertificate: {
        options: {
            data: {
                rootCertificate: 'self-signed-root-ca.crt.pem',
                sslUrl: '<%= config.url.debug %>'
            }
        },
        files: {
            '<%= config.dir.localhostCertificate %>/index.html': 'src/install-cert/index.html'
        }
    },
    debug: {
        options: {
            data: {
                manifestUrl: '<%= config.url.debug %>/Manifest.debug.plist',
                configuration: 'DEBUG'
            }
        },
        files: {
            '<%= config.dir.debug %>/index.html': 'src/install-app/index.html'
        }
    },
    dev: {
        options: {
            data: {
                manifestUrl: '<%= config.url.dev %>/Manifest.dev.plist',
                configuration: 'DEV'
            }
        },
        files: {
            '<%= config.dir.dev %>/index.html': 'src/install-app/index.html'
        }
    },
    test: {
        options: {
            data: {
                manifestUrl: '<%= config.url.test %>/Manifest.test.plist',
                configuration: 'TEST'
            }
        },
        files: {
            '<%= config.dir.test %>/index.html': 'src/install-app/index.html'
        }
    },
    production: {
        options: {
            data: {
                manifestUrl: '<%= config.url.production %>/Manifest.production.plist',
                configuration: 'PRODUKTION'
            }
        },
        files: {
            '<%= config.dir.production %>/index.html': 'src/install-app/index.html'
        }
    }
};