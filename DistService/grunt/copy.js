module.exports = {
    localhostCerticate: {
        expand: true,
        cwd: 'certificates/client',
        src: 'self-signed-root-ca.crt.pem',
        dest: '<%= config.dir.localhostCertificate %>'
    }
};
