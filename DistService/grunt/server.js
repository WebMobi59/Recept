module.exports = function(grunt) {
	grunt.registerTask('server', [
		'connect:localhostCertificate',
		'connect:debug'
	]);
};
