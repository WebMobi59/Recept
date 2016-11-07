module.exports = function(grunt) {
	grunt.registerTask('build:debug', [
		'processhtml:debug',
		'manifest:debug',
		'clean:debug',
		'xcode:debug'
	]);
	grunt.registerTask('build:dev', [
		'processhtml:dev',
		'manifest:dev',
		'clean:dev',
		'xcode:dev'
	]);
	grunt.registerTask('build:test', [
		'processhtml:test',
		'manifest:test',
		'clean:test',
		'xcode:test'
	]);
	grunt.registerTask('build:production', [
		'processhtml:production',
		'manifest:production',
		'clean:production',
		'xcode:production'
	]);
	grunt.registerTask('build:release', [
		'clean:release',
		'xcode:release'
	]);
};
