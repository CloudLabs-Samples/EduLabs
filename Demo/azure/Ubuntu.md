# Demo Lab : Linux Virtual machine

# Scenario

You are a Linux System Administrator onboarding a new production web application server for an internal business team.
Your task is to prepare the server with a secure user, deploy a simple web service, configure logging, verify access, and perform health checks — all using the terminal.

1.Verify Server Identity

```
whoami
hostname
hostname -I
uptime
```
2. Create Application User and Group

```
sudo groupadd webops
sudo useradd -m -G webops webadmin
id webadmin
```
3. Create Application Directories and assign permissions
```
sudo mkdir -p /var/www/demoapp/{html,logs}
sudo chown -R webadmin:webops /var/www/demoapp
sudo chmod -R 750 /var/www/demoapp
```
4. Install and start Web Server (Nginx)
```
sudo apt update
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
systemctl status nginx --no-pager
```
5. Deploy Application Content
```
sudo -u webadmin tee /var/www/demoapp/html/index.html <<EOF
<h1>Linux Demo Server is Live</h1>
<p>Deployed on: $(date)</p>
EOF
```
6. Configure Nginx Site
```
sudo tee /etc/nginx/sites-available/demoapp <<EOF
server {
    listen 80 default_server;
    server_name _;
    root /var/www/demoapp/html;
    index index.html;
    access_log /var/www/demoapp/logs/access.log;
}
EOF
```
Disable default site and enable demo site:
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/demoapp /etc/nginx/sites-enabled/

Validate and reload:
```
sudo nginx -t
sudo systemctl reload nginx
```
7. Verify Web Application
```
curl http://localhost
```

8. Monitor Logs and Health
```
sudo tail -f /var/www/demoapp/logs/access.log
```
