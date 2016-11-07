module.exports = function(grunt) {
	var fs = require('fs');
	var plist = require('plist');

	grunt.registerMultiTask('plistbump', 'Bumps build number and version string in specified plist', function() {
		var options = this.options({
			plist: '../Recept/Info.plist',
			appBuild: '0.1.0',
			appVersion: '0.1.0'
		});

		options.appBuild = grunt.option('appBuild') || options.appBuild;
		options.appVersion = grunt.option('appVersion') || options.appVersion;

		var contentJson = plist.parse(fs.readFileSync(options.plist, 'utf8'));
		contentJson.CFBundleVersion = options.appBuild;
		contentJson.CFBundleShortVersionString = options.appVersion;

		var contentPlist = plist.build(contentJson);

		console.log('\n\n************************************\n************************************\n\n');
		console.log("Writing CFBundleVersion = " + options.appBuild + " to " + options.plist);
		console.log("\nWriting CFBundleShortVersionString = " + options.appVersion + " to " + options.plist);
		fs.writeFileSync(options.plist, contentPlist);
		console.log('\n\n************************************\n************************************\n\n');
	});
};
