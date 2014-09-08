/**
 *
 * Runs Mocha tests.
 *
 * ---------------------------------------------------------------
 *
 * # dev task config
 * Copies all directories and files, exept coffescript and less fiels, from the sails
 * assets folder into the .tmp/public directory.
 *
 * # build task config
 * Copies all directories nd files from the .tmp/public directory into a www directory.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-copy
 */
module.exports = function(grunt) {

	grunt.config.set('mochaTest', {
		test: {
			options: {
				reporter: 'spec', 
				timeout: '20000',
				require: 'coffee-script/register'
			},
			src: ['tests/**/*.spec.js', 'tests/**/*.spec.coffee']
		}
	});

	grunt.loadNpmTasks('grunt-mocha-test');

};
