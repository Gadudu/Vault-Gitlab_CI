<h1 align="center"> Simple Flask web app using Gitlab ci and Hashicorp Vault </h1>
<br/>
<p> 
  In this project I created a small python app the can retrieve a scret from vault and display adjusted content based on the success of the retrieval.
  <br/>
  other than that the app is tested for connectivity, packaged in a docker container, and saved in Gitlab Container Registry 
</p>

<h3>&ensp; Hosts in use:</h3>
<ul>
 <li>Host1= Vault server with static IP: 3.228.30.171
  <br/> &emsp; DNS: ec2-3-228-30-171.compute-1.amazonaws.com 
 </li>
 <li>Host2= Gitlab server with static IP: 52.3.58.227
   <br/> &emsp; DNS: ec2-52-3-58-227.compute-1.amazonaws.com
 </li>
 <li>Host3= Gitlab runner with dinamic IP
   <br/> &emsp; Contact using private IP in subnet      
 </li>
</ul>
| Please ping hosts before using them

<h2 align="center"> How to install and use </h2>

<h4>For those who only want the final app: </h4>
<br/>
<ul>
 <li>Access <a href="https://ec2-52-3-58-227.compute-1.amazonaws.com/root/simplepyapp/container_registry/1">My_Registry</a></li>
 <li>Choose wanted tag</li>
 <li>docker run -d --name test -p 5000:5000 ec2-52-3-58-227.compute-1.amazonaws.com:5050/root/simplepyapp/simple-web-app:{SELECTED_TAG}
    <br/> &emsp; Replace SELECTED_TAG with the tag you chose
 </li>
 <li>and the app runs on your local host on port 5000
    <br/> &emsp; Change the port forwarding to which ever port comfortable</ol>
 </li>
</ul>
<h2>Configurations</h2>
<h3> Gitlab: </h3>
<ul>
  <li>Set up ec2 t3.large instance with ubuntu</li>
  <li>Open security Groups for 22, 80, 443, 5050, and 2424</li>
  <li>change default server ssh port to 2424 to keep 22 open for Gitlab</li>
  <li>install docker like explained in docker documentation
  <br/>see referances</li>
  <li>Get gitlab docker compose from /Extras/Gitlab
      <ol>
        <li>image - gitlab/gitlab-ce:16.10.1-ce.0</li>
        <li>external_url= 'https://Host2'</li>
        <li>disable lets_encrypt (Manual SSL configuration)</li>
        <li>redirect http to https to listen on 80</li>
        <li>registry_external_url= 'https://Host2:5050'</li>
        <li>port 5050 to Container Registry, port 22 to SSH
            <br/>port 80/443 to HTTP/S
        </li>
        <li>config. logs, data MUST HAVE VOLUMES!!
            <br/>ssl volume for self signed certificates
        </li>
      </ol>
  </li>
  <li>RUN docker compose up -d</li>
  <li>get /Extras/CertMaker/* &ensp;files
      <ol>
          <li>change relevant lines and details in san.conf</li>
          <li>run CertMaker.sh</li>
          <li>remove *.csr file</li>
          <li>change files mode to 600</li>
          <li>change files owner to relevent user (Here root)</li>
          <li>rename files to Host2.key and Host2.crt</li>
          <li>place them (*.key, *.crt) in $GILAB_HOME/ssl/</li>
      </ol>
  </li>
  <li>RUN docker compose down && docker compose up -d</li>
  <li>Gitlab instance set up !!! <br/>
      recommended to set up non-admin user for work
  </li>
</ul>


<h3> Gitlab Runner</h3>
<ul>
    <li>run the following commands</li>

    curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
    sudo apt update && sudo apt install gitlab-runner=16.10.0

<li>this will install the runner as a service with gitlab-runner user</li>
    <li>at /etc/gitlab-runner make certs directory owned by root</li>
    <li>cp Gitlab Host2.crt to that folder</li>
    <li>on Gitlab UI click New Instance Runner</li>

    sudo gitlab-runner register --tls-ca-file /etc/gitlab-runner/certs/Host2.crt --url https://Host2  --token {insert token got from gitlab ui}

    sudo systemctl restart gitlab-runner

<li>Gitlab runner is installed and registered now let's configure</li>
    <li>install docker like we did in Gitlab</li>
</ul>
