
# Berrybouy FTP

**Single run for a simple FTP / SFTP server in AWS**

Use [vagrant](https://www.vagrantup.com/) to create a FTP / SFTP server for a single user on one of the [smallest instance](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/t2-instances.html) of [AWS](http://aws.amazon.com) and store your uploaded data directly on a [S3 bucket](https://aws.amazon.com/s3/?nc1=h_ls).

## Dependency

* [vagrant](https://www.vagrantup.com/)
	* optional [virtualbox](https://www.virtualbox.org/)
* A [AWS](http://aws.amazon.com) account
	* Your Amazon web service credential 
	* A Amazon S3 bucket
	* A Amazon Route53 DNS zone

## Setting

Complete `settings.yaml` file with your information :

- **vagrant:** *information for vagrant*
  - **hostname:** The Server hostname
  - **owner:** Yourname
  - **user:** the ftp user name account 
  - **user_password:** A strong password for the ftp user
  - **domain:** The domaine name of your route 53 zone
  - **motd:** "---------- Server is ready ----------"
- **vb:** *information for virtualbox if needed* 
  - **vm_box:** "ubuntu/trusty64" *Change with care*
  - **vm_box_check_update:** true *Change with care*
  - **ssh_username:** vagrant *Change with care*
  - **mem:** 2048 *Change with care*
  - **cpus:** 2 *Change with care*
- **aws:**
  - **vm_box:** dummy *Change with care*
  - **vm.box_url:** "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box" *Change with care*
  - **ssh_username:** ubuntu *Change with care*
  - **ssh_private_key_path:** "/Users/you/.ssh/id_rsa"
  - **s3_bucket:** Your S3 bucket name
  - **aws_access_key_id:** your aws access key
  - **aws_secret_access_key:** your aws secret access key
  - **aws_keypair_name:** you.id_rsa.pub
  - **aws_instance_type:** t2.micro *Change with care*
  - **aws_monitoring:** false *Change with care*
  - **aws_elastic_ip:** false *Change with care* 
  - **aws_associate_public_ip:** false *Change with care*
  - **aws_instance_ready_timeout:** 240 *Change with care*
  - **aws_region:** us-east-1 *Change with care*
  - **aws_region_ami:** ami-0f8bce65 *Change with care*
  - **aws_security_groups:** Your Security Groupe name
  - **route53_hosted_zone_id:** your route 53 zone id

