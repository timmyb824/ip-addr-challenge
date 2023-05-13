def secrets = [
  [path: 'secret/ip-addr-app/proxmox', engineVersion: 2, secretValues: [
    [envVar: 'HOST', vaultKey: 'HOST'],
    [envVar: 'PORT', vaultKey: 'PORT'],
    [envVar: 'SSH_USER', vaultKey: 'SSH_USER']]],
]

def configuration = [vaultUrl: 'https://vault.local.timmybtech.com/',  vaultCredentialId: 'vault-token', engineVersion: 2]

pipeline {
    agent any

    stages {
        stage('Deploy') {
            steps {
                script {
                    // SSH credentials (from Jenkins credentials store)
                    def sshCredentials = credentials('SSH_CREDENTIALS_ID')

                    // SSH connection details
                    def sshServer = [
                        name: 'vm400',
                        host: ${env.HOST},
                        port: ${env.PORT},
                        user: ${env.SSH_USER},
                        credentialsId: sshCredentials.id
                    ]

                    // Path to your application directory on the server
                    def appPath = '/home/ubuntu/ip-addr'

                    // Git pull and restart commands
                    def gitPullCommand = "cd ${appPath} && git pull"
                    def restartCommand = "systemctl restart ip-addr.service"

                    // SSH to server and execute commands
                    sshCommand sshServer, gitPullCommand
                    sshCommand sshServer, restartCommand
                }
            }
        }
    }
}
