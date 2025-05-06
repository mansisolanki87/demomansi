#!/usr/bin/env groovy 

/*
 * This file bootstraps the codified Continuous Delivery pipeline for extensions of SAP solutions such as SAP S/4HANA.
 * The pipeline helps you to deliver software changes quickly and in a reliable manner.
 * A suitable Jenkins instance is required to run the pipeline.
 * More information on getting started with Continuous Delivery can be found here: https://www.project-piper.io/
 */

// @Library('piper-lib-os') _

// piperPipeline script: this

pipeline {
    agent any

    environment {
        MTA_PATH = "${WORKSPACE}"
        MTAR_NAME = "UI%CAPM.mtar"
        CF_API_ENDPOINT = "https://api.cf.us10-001.hana.ondemand.com"
        CF_ORG = "f86034d7-b0fe-49c7-8c42-3b043a384f18"
        CF_SPACE = "32802711-1e00-4aee-8ab6-b158273793f8"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                dir("${MTA_PATH}") {
                    sh 'npm install'
                }
            }
        }

        stage('Build CAP Artifacts') {
            steps {
                dir("${MTA_PATH}") {
                    sh 'npx cds build'
                }
            }
        }

        stage('Deploy CAP Artifacts') {
            steps {
                dir("${MTA_PATH}") {
                    sh 'npx cds deploy'
                }
            }
        }

        stage('Build MTA Project') {
            steps {
                dir("${MTA_PATH}") {
                    sh 'mbt build'
                }
            }
        }

        stage('Package MTAR') {
            steps {
                dir("${MTA_PATH}") {
                    sh 'make -f Makefile.mta p=CF mtar=${MTAR_NAME} strict=true mode= t="${MTA_PATH}"'
                }
            }
        }

        stage('Deploy to CF') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'cf', usernameVariable: 'CF_USERNAME', passwordVariable: 'CF_PASSWORD')]) {
                    sh """
                        cf login -a ${CF_API_ENDPOINT} -u ${CF_USERNAME} -p ${CF_PASSWORD} -o ${CF_ORG} -s ${CF_SPACE}
                        cf deploy mta_archives/${MTAR_NAME} -f
                    """
                }
            }
        }
        
        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: "mta_archives/${MTAR_NAME}", fingerprint: true
            }
        }
    }

    post {
        failure {
            echo 'Build failed. Please check the logs above.'
        }
    }
}