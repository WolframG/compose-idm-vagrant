compose-idm-vagrant
===================

Project including necessary scripts to build automatically compose-idm with the proper UAA version in a virtual machine with vagrant


# Why Vagrant

Vagrant lets you build virtual machines by just executing a command. This project will build compose-idm (https://github.com/nopbyte/compose-idm) for you in just a couple of commands from your terminal. 

#What is installed

This project installs:

* UAA (from Cloud Foundry): Installs a version that has been precompiled into a war file
* Compose-idm: The latest version from the github repository
* MySQL database: This database is used for the UAA, and for idm. With diferent schemes and users of course...
* Tomcat7: used to run compose-idm and the UAA.
* Gradle: used to build compose-idm
* curl
* unzip
* open jdk

#How to run it

First you need to get Vagrant here: https://www.vagrantup.com/

Now you will need to add the ubuntu 64 bit image by executing:

  $ vagrant box add precise64 http://files.vagrantup.com/precise64.box 

For more info see: https://docs.vagrantup.com/v2/providers/basic_usage.html

Now, you just need to get the project from the repo by running:

  $ git clone https://github.com/nopbyte/compose-idm-vagrant
  $ cd compose-idm-vagrant
  $ vagrant up

Afterwards vagrant will map the endpoint for compose-idm to your (local host machine) 8080. So you can execute something like the following line, either in your local host machine, or inside the vagrant virtual machine to test compose-idm functionality:

  $ curl --digest -u "composecontroller:composecontrollerpassword"  -H "Content-Type: application/json;charset=UTF-8" -d '{"username":"test2","password":"pass"}' http://localhost:8080/idm/user/

Please have a little patience when the vagrant up command finishes... it still takes a couple of seconds for compose-idm to come up completely due to the ammount of components that need to be loaded ;)

Any password (or configuration) change should be done in the configuration (or the bootstrap.sh script) files for this project, since they replace what is in compose-idm github before compiling everything. Also if you want to change the port that is mapped in your host... just change the property  host in the following line in the Vagrantfile: config.vm.network "forwarded_port", guest: 8080, host: 8080

Enjoy!



