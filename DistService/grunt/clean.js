module.exports = {
    debug: ['<%= config.dir.debug %>/*.ipa'],
    dev: ['<%= config.dir.dev %>/*.ipa'],
    test: ['<%= config.dir.test %>/*.ipa'],
    production: ['<%= config.dir.production %>/*.ipa'],
    release: ['<%= config.dir.release %>/*.ipa'],
    dist: ['<%= config.dir.dist %>']
};
