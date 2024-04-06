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
 <li>Access https://ec2-52-3-58-227.compute-1.amazonaws.com/root/simplepyapp/container_registry/1 </li>
 <li>Choose wanted tag</li>
 <li> ``` 
    <br/>
    docker run -d --name test -p 5000:5000 ec2-52-3-58-227.compute-1.amazonaws.com:5050/root/simplepyapp/simple-web-app:{SELECTED_TAG}
    <br/>
      ```
    <br/> &emsp; Replace SELECTED_TAG with the tag you chose
 </li>
 <li>and the app runs on your local host on port 5000
    <br/> &emsp; Change the port forwarding to which ever port comfortable</ol>
 </li>
</ul>
