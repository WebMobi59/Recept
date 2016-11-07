module.exports = function(grunt) {
	var fs = require('fs');
	var pathSep = require('path').sep;
	var plist = require('plist');

	grunt.registerMultiTask('manifest', 'Outputs manifest plist file for .ipa download to specified file destination', function() {
		var options = this.options({
			destinationDir: 'dist/debugSSL',
			destinationFileName: 'manifest.plist',
			url: 'https://localhost.apoteket.se:8000/Recept.ipa',
			bundleIdentifier: 'se.apoteket.enterprise.Recept',
			title: 'Recept'
		});

		var projectPlist = plist.parse(fs.readFileSync('../Recept/Info.plist', 'utf8'));

		var bundleVersion = projectPlist.CFBundleShortVersionString;

		var manifestJSON = {
			items: [{
				assets: [{
					kind: 'software-package',
					url: options.url
				}],
				metadata: {
					'bundle-identifier': options.bundleIdentifier,
					'bundle-version': bundleVersion,
					kind: 'software',
					title: options.title
				}
			}]
		};

		var manifestPlist = plist.build(manifestJSON);

		var filePath = options.destinationDir + '/' + options.destinationFileName;
		grunt.file.mkdir(options.destinationDir);
		fs.writeFileSync(filePath, manifestPlist);
		console.log('Manifest written to: ' + filePath);

		console.log('\n\n************************************\n************************************\n\n');
		console.log('DO NOT FORGET TO BUMP BUNDLE VERSION\n\nCurrent version: ' + bundleVersion);
		console.log('\n\n************************************\n************************************\n\n');
	});
};