module.exports = {
    debug: {
        options: {
			destinationDir: '<%= config.dir.debug %>',
			destinationFileName: 'Manifest.debug.plist',
			url: '<%= config.url.debug %>/Recept-Debug.ipa',
			bundleIdentifier: '<%= config.app.enterprise.bundleIdentifier %>',
			title: 'Recept'
        }
    },
    dev: {
        options: {
			destinationDir: '<%= config.dir.dev %>',
			destinationFileName: 'Manifest.dev.plist',
			url: '<%= config.url.dev %>/Recept-Dev.ipa',
			bundleIdentifier: '<%= config.app.enterprise.bundleIdentifier %>',
			title: 'Recept'
        }
    },
    test: {
        options: {
			destinationDir: '<%= config.dir.test %>',
			destinationFileName: 'Manifest.test.plist',
			url: '<%= config.url.test %>/Recept-Test.ipa',
			bundleIdentifier: '<%= config.app.enterprise.bundleIdentifier %>',
			title: 'Recept'
        }
    },
    production: {
        options: {
			destinationDir: '<%= config.dir.production %>',
			destinationFileName: 'Manifest.production.plist',
			url: '<%= config.url.production %>/Recept-Production.ipa',
			bundleIdentifier: '<%= config.app.enterprise.bundleIdentifier %>',
			title: 'Recept'
        }
    }
};