# JIRA xbarapp

Script to fetch information from JIRA and send it to [xbarapp](https://xbarapp.com/).
The current version takes information from specific servicedesk queue.


## Table of contents

* [Configurarion](#configuration)
  - [Ruby installation](#ruby-installation)
  - [Install xbarapp](#install-xbarapp)
  - [Create JIRA token](#create-jira-token)
  - [Set global environment variables](#set-global-environment-variables)
  - [Adapt script](#adapt-script)
  - [Make script executable](#make-script-executable)
  - [Link script to xbarapp](#link-script-to-xbarapp)
  - [Refresh xbarapp](#refresh-xbarapp)
* [Execution screenshots](#execution-screenshots)
  - [No tickets to solve](#no-tickets-to-solve)
  - [Tickets in progress](#tickets-in-progress)
  - [Tickets waiting for customer](#tickets-waiting-for-customer)
  - [Has tickets to solve](#has-tickets-to-solve)


## Configuration
### Ruby installation
The script requires ruby (2.6.8+). You can find installation instructions [here](https://www.ruby-lang.org/en/documentation/installation/).
### Install xbarapp
Follow the instructions in their [site](https://xbarapp.com/).

### Create JIRA token
Go to token creation's [page](https://id.atlassian.com/manage-profile/security/api-tokens) and do it.

### Set global environment variables
In macos you can do the following:

    launchctl setenv "JIRA_USER_EMAIL" EMAIL_USED_IN_JIRA
    launchctl setenv "JIRA_API_TOKEN" JIRA_API_TOKEN_HERE

### Adapt script
The script is fetching tickets from queue 18 at servicedesk 1.
You gotta change that accordingly:

    queue = JiraClient.new.get_queue(servicedesk_id: 1, queue_id: 18)

### Make script executable
In macos you can do the following:

    chmod a+x PATH/jira_script.rb

Change the PATH to the directory path where you did clone the project into.

### Link script to xbarapp
In macos you can do the following:

    ln -s PATH/jira_script.rb XBAR_PATH/xbar/plugins/jira-attendance-support-tickets.1m.rb

Change the PATH to the directory path where you did clone the project to.

Change the XBAR_PATH to the directory path where you did install your xbarapp.

### Refresh xbarapp
Left-click the xbarapp and hit `Refresh all` in the `xbar` menu;

## Execution screenshots
### No tickets to solve
![image](https://user-images.githubusercontent.com/1873442/160581965-61bdd4e0-3ae4-4c1b-a3d2-b2f54dbee6b0.png)

### Tickets in progress
<img width="268" alt="image" src="https://user-images.githubusercontent.com/1873442/160601268-69d60277-54c4-4d72-8826-42e2305643b5.png">


### Tickets waiting for customer
![image](https://user-images.githubusercontent.com/1873442/160582012-bf677637-b788-416e-b184-b588cf2426ea.png)

### Has tickets to solve
![image](https://user-images.githubusercontent.com/1873442/160582042-015c7bcc-07da-432d-be70-98b74cb52fb3.png)
