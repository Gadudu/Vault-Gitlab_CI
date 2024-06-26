<h1 align="center"> Simple Flask web app using Gitlab ci and Hashicorp Vault </h1>
<br/>
<p>In this project I created a small python app the can retrieve a scret from vault and display adjusted content based on the success of the retrieval.</p>
<p>other than that the app is tested for connectivity, packaged in a docker container, and saved in Gitlab Container Registry </p>
<br/>

<p>|&emsp;Important!! we work with many files here. allways make sure the files permmision fit the user who will use it</p>

<h3>&ensp; Hosts in use:</h3>
<ul>
    <li>Host1= Vault server with static IP: 3.228.30.171
        <br/>-&emsp;DNS: ec2-3-228-30-171.compute-1.amazonaws.com 
    </li>
    <li>Host2= Gitlab server with static IP: 52.3.58.227
        <br/>-&emsp;DNS: ec2-52-3-58-227.compute-1.amazonaws.com 
    </li>
    <li>Host3= Gitlab runner with dinamic IP
        <br/>-&emsp;Contact using private IP in subnet 
    </li>
</ul>
<p>|&emsp;please ping hosts before using them</p>

<br/>
<h2 align="center"> How to install and use </h2>

<h4>For those who only want the final app:<h4>
<br/>
<ul>
    <li>Access https://ec2-52-3-58-227.compute-1.amazonaws.com/root/simplepyapp/container_registry/1</li>
    <li>Choose wanted tag</li>
</ul>

        docker run -d --name test -p 5000:5000 ec2-52-3-58-227.compute-1.amazonaws.com:5050/root/simplepyapp/simple-web-app:{SELECTED_TAG}

<p>|&emsp;Replace SELECTED_TAG with the tag you chose</p>
<ul>
    <li>and the app runs on your local host on port 5000
        <br/>-&emsp;Change the port forwarding to which ever port comfortable
    </li>
</ul>

<br/>
<h2 align="center">Configurations</h2>
<h3> Gitlab: </h3>
<h4> prerequisites </h4>
<ul>
    <li>set up ec2 t3.large instance with ubuntu ima.</li>
    <li>open security groups for 22, 80, 443, 5050, and 2424.</li>
    <li>change default server ssh port to 2424 to keep 22 open for gitlab.</li>
    <li>install docker like explained in docker documentation
    <br/>-&ensp; see referances</li>
</ul>

<h4>Docker Compose</h4>
<p>Get gitlab docker compose from /Extras/Gitlab</p>
<ol>
    <li>image: gitlab/gitlab-ce:16.10.1-ce.0</li>
    <li>external_url: 'https://Host2'</li>
    <li>lets_encrypt: disabled (Manual SSL configuration)</li>
    <li>redirect http to https: true to listen on 80</li>
    <li>registry_external_url: 'https://Host2:5050'</li>
    <li>ports:
        <ul>
            <li>5050 - Gitlab Container Registry</li>
            <li>22 - Gitlab SSH</li>
            <li>443 - HTTPS Gitlab UI</li>
            <li>80 - Redirected to 443</li>
        </ul>
    </li>
    <li>volumes:
        <ul>
            <li>config - mandatory</li>
            <li>logs - mandatory</li>
            <li>data - mandatory</li>
            <li>ssl - optional volume for self signed certificates</li>
    </li>
</ol>

<p>RUN docker compose up -d</p>

<h4>Certificate</h4>
<ul>
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
</ul>
<p>|&emsp;recommended to set up non-admin user for work</p>

<h3> Vault Server </h3>
<h4> prerequisites </h4>
<ul>
    <li>set up ec2 m5.large instance with ubuntu ima.</li>
    <li>open security groups for 22 (SSH) and 8200.</li>
</ul>

<h4> Installationn </h4>
<p>Run the following commands:</p>

    sudo apt update && sudo apt install gpg wget
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install vault

<h4>Certificate</h4>
<ul>
   <li>repeat the same steps to create a certificate like you did with gitlab</li>
   <li>move vault.key and vault.crt to /opt/vault/tls</li>
   <li>open the file /etc/vault.d/vault.hcl</li>
   <li>set tls_cert_file and tls_key_file to have the propper locations</li> 
</ul>
<h4>Pre-Configure</h4>
<p>Declare the following variables</p>

    export VAULT_ADDR='https://Host1:8200'
    export VAULT_CACERT='<path_to_the_created_vault.crt_file>'

<h4>First start up</h4>
<p>Run the command:</p>

    vault operator init

<p>this will initiallize the vault with defaults of 5 key shares and 3 key theshold (quorum)</p>

<h4>Unseal</h4>
<p>Now all you have to do is enter 3 key parts and vault is up and unsealed</p>


<h3> Gitlab Runner </h3>
<h4> prerequisites </h4>
<ul>
    <li>set up ec2 t3.medium instance with ubuntu ima.</li>
    <li>open security groups only for 22 SSH</li>
</ul>

<h4> Installation </h4>
<p>Run the following commands:</p>

    curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
    sudo apt update && sudo apt install gitlab-runner=16.10.0

<p>this will install the runner as a service with gitlab-runner user</p>

<br/>
<h4>Trust the Gitlab Server's certificate</h4>
<ul>
    <li>at /etc/gitlab-runner make certs directory owned by root</li>
    <li>cp Gitlab Host2.crt to that folder</li>
    <li>on Gitlab UI click New Instance Runner and find the token</li>
</ul>
<p>Run the following commands:</p>

    sudo gitlab-runner register --tls-ca-file /etc/gitlab-runner/certs/Host2.crt --url https://Host2  --token {insert token got from gitlab ui}

    sudo systemctl restart gitlab-runner

<br/>    
<h4> Trust Vault server</h4>
<p>copy vault.crt that we created earlier at /home/gitlab-runner/</p>

<br/>
<h4>Set up Runner dependencies</h4>
<p>Install docker the same way we did in Gitlab part</p>  
 
<p>For vault cli do the following commands:</p>

    curl https://releases.hashicorp.com/vault/{version}/vault_{version}_linux_amd64.zip -o vault_{version}_linux_amd64.zip
    curl https://releases.hashicorp.com/vault/{version}/vault_{version}_SHA256SUMS -o vault_{version}_SHA256SUMS
    sha256sum --ignore-missing -c vault_{version}_SHA256SUMS
    unzip ./vault_{version}_linux_amd64.zip
    sudo chmod 755 ./vault
    sudo chown root:root ./vault
    sudo mv ./vault /usr/local/bin/

<p>|&emsp;replace version with wanted version I chose 1.16.0</p>
<p>And run 'vault' command to see if it works</p> 

<br/>
<h2 align="center">Setting and Setup</h2>
<h3>Gitlab Server</h3>
<ul>
    <li>open new project</li>
    <li>push files to it</li>
    <li>setup gitlab-ci.yml file (explained later)</li>
    <li>register runner like descripted above and give tag</li>
    <li>define the following environment variables in Project>Settings>CI/CD:
        <ul>
            <li>VAULT_ADDR= Vault server Address</li>
            <li>VAULT_CACERT= Path to vault.crt in gitlab-runner home</li>
            <li>VAULT_PASS= Vault user 'multics' password</li>
            <li>VAULT_USER= 'multics' user from vault to auth to</li>
        </ul>
    </li>
</ul>

<h3>Vault Server</h3>
<ul>
    <li>set up a new user ('multics')</li>
    <li>enable k/v engine</li>
    <li>set up a secret on k/v engine of Assignment=complete</li>
    <li>create a policy that allows reading this secret</li>
    <li>connect that policy to the user</li>
    <li>set the user to be authenticated for 30s before the need to reauthenticate</li>
</ul>

<br/>
<h2 align="center"> CI / CD </h2>
<p>|&emsp;the steps go as followed:</p>
<ul>
    <li>build stage:
        <ul>
            <li>try getting secret from vault authenticating as 'multics'</li>
            <li>build the image of the project using a docker file and ARG injection</li>
            <li>run the container locally for tests</li>
        </ul>
    </li>
    <li>test stage: test connectivity by curl</li>
    <li>keep-artifact stage:
        <ul>
            <li>login to my registry using built in variables</li>
            <li>push the image i created</li>
            <li>log out of registry</li>
        </ul>
    </li>
    <li>cleanup stage:
        <ul>
            <li>stop the tests container</li>
            <li>remove the tests container</li>
            <li>remove the allready pushed image</li>
            <li>prune the system from unused cache</li>
        </ul>
    </li>
</ul>

<h2 align="center">Referances</h2>
<ul>
    <li>/Extras/Gitlab/docker-compose.yml = based on https://docs.gitlab.com/ee/install/docker.html </li>
    <li>/Extras/Docker_Install/DocInstall.sh = https://docs.docker.com/engine/install/ubuntu/</li>
    <li>/Extras/CertMaker/ = Made it alone compiled from many resources to insert SAN (Subject Alternative Names)</li>
</ul>
