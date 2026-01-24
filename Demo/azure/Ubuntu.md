# Demo Lab :Linux Web Application Deployment and Server Configuration 

## Scenario

You are a Linux System Administrator responsible for preparing a new production web application server for an internal business team.
The team requires a secure and reliable environment to host their application and monitor basic system activity.

Your task is to configure the server by creating a dedicated application user and group, setting up the required directory structure with proper permissions, deploying a web service, and enabling access logging.
You will also validate that the application is accessible and perform basic system health checks to ensure the server is ready for operational use.

## Lab Steps

1. From the Virtual machine, Open a Terminal to run the commands.

2. Verify Server Identity

```
whoami
hostname
hostname -I
uptime
```
3. Create Application User and Group

```
sudo groupadd webops
sudo useradd -m -G webops webadmin
id webadmin
```
4. Create Application Directories and assign permissions
```
sudo mkdir -p /var/www/demoapp/{html,logs}
sudo chown -R webadmin:webops /var/www/demoapp
sudo chmod -R 750 /var/www/demoapp
```
5. Install and start Web Server (Nginx)
```
sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
systemctl status nginx --no-pager
```
6. Deploy Application Content
```
sudo -u webadmin tee /var/www/demoapp/html/index.html <<EOF
<h1>Linux Demo Server is Live</h1>
<p>Deployed on: $(date)</p>
EOF
```
7. Configure Nginx Site
```
sudo tee /etc/nginx/sites-available/demoapp <<EOF
server {
    listen 80;
    server_name _;
    root /var/www/demoapp/html;
    index index.html;
    access_log /var/www/demoapp/logs/access.log;
}
EOF
```
8.Remove Default Nginx Configuration

```
sudo rm -f /etc/nginx/sites-enabled/default
sudo rm -f /etc/nginx/conf.d/*
```

9. Enable Demo Site and Reload Nginx
   ```
   sudo ln -sf /etc/nginx/sites-available/demoapp /etc/nginx/sites-enabled/demoapp
   
   sudo nginx -t
   
   sudo systemctl reload nginx
   ```

10. Configure Web Server Access Permissions
  
   Grant the Nginx service user (www-data) access to the application files.
   ```
   sudo usermod -aG webops www-data
   
   sudo systemctl restart nginx
   ```

11. Verify Web Application
   ```
   curl http://localhost
   ```

or check in any browser : http:localhost

## Conclusion
In this lab, a Linux web application server was successfully configured using core system administration commands.
The application was deployed, permissions were secured, and the web service was verified through both command-line and browser access.

This lab demonstrates essential Linux skills required for real-world server setup and management.
