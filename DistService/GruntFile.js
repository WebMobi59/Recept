module.exports = function(grunt) {
	var config = {
		dir: {
			dist: 'dist',
			debug: 'dist/debug',
			dev: 'dist/dev',
			test: 'dist/test',
			production: 'dist/production',
			release: 'dist/release',
			localhostCertificate: 'dist/localhostCertificate'
		},
		url: {
			localhostCertificate: 'http://localhost.apoteket.se:7000',
			debug: 'https://rxapp-download.apoteket.se/ios/debug',
			dev: 'https://rxapp-download.apoteket.se/ios/dev',
			test: 'https://rxapp-download.apoteket.se/ios/test',
			production: 'https://rxapp-download.apoteket.se/ios/production',
			release: null
		},
		app: {
			enterprise: {
				provisioningProfile: 'ReceptEnterpriseDist',
				bundleIdentifier: 'se.apoteket.enterprise.Recept' // BundleIdentifier only needed for enterprise, since it bundles for internal download
			},
			release: {
				provisioningProfile: 'ReceptRelease'
			},
			workspace: '../Recept.xcworkspace'
		}
	};
	// load grunt config
	require('load-grunt-config')(grunt, {
		// data passed into config.
		data: {
			config: config
		}
	});
};
