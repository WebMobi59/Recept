module.exports = {
    debug: {
        options: {
            exportPath: '<%= config.dir.debug %>',
            exportFilename: 'Recept-Debug',
            exportFormat: 'IPA',
            workspace: '<%= config.app.workspace %>',
            scheme: 'Recept-Debug',
            configuration: 'Release',
            exportProvisioningProfile: '<%= config.app.enterprise.provisioningProfile %>',
            clean: false
        }
    },
    dev: {
        options: {
            exportPath: '<%= config.dir.dev %>',
            exportFilename: 'Recept-Dev',
            exportFormat: 'IPA',
            workspace: '<%= config.app.workspace %>',
            scheme: 'Recept-Dev',
            configuration: 'Release',
            exportProvisioningProfile: '<%= config.app.enterprise.provisioningProfile %>',
            clean: false
        }
    },
    test: {
        options: {
            exportPath: '<%= config.dir.test %>',
            exportFilename: 'Recept-Test',
            exportFormat: 'IPA',
            workspace: '<%= config.app.workspace %>',
            scheme: 'Recept-Test',
            configuration: 'Release',
            exportProvisioningProfile: '<%= config.app.enterprise.provisioningProfile %>',
            clean: false
        }
    },
    production: {
        options: {
            exportPath: '<%= config.dir.production %>',
            exportFilename: 'Recept-Production',
            exportFormat: 'IPA',
            workspace: '<%= config.app.workspace %>',
            scheme: 'Recept-Production',
            configuration: 'Release',
            exportProvisioningProfile: '<%= config.app.enterprise.provisioningProfile %>',
            clean: false
        }
    },
    release: {
        options: {
            exportPath: '<%= config.dir.release %>',
            exportFilename: 'Recept-Release',
            exportFormat: 'IPA',
            workspace: '<%= config.app.workspace %>',
            scheme: 'Recept-Release',
            configuration: 'Release',
            exportProvisioningProfile: '<%= config.app.release.provisioningProfile %>',
            clean: false
        }
    }
};
