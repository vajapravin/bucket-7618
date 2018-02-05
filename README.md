We work on the Google Cloud Platform (GCP). We run simulations on machines with typically 16 cores or more. Those are expensive!
Therefore, we start up a dedicated virtual machine for each simulation: we create the machine, upload the necessary files (3D model, json file with simulation parameters) and call the command for the simulation. Once the simulation is finished, transfer the data back to the main server and kill the virtual machine.

The challenge:
- Create a free account on the GCP (google cloud platform). You should get around 300 dollars’ worth of credits 😊
- Server VM: make a virtual machine (you can take the smallest one if you like) that will act as the main server. Store a dummy input.json file on the server.
- Simulation VM: this is a new virtual machine that will be started from the server VM. Instead of using a standard Ubuntu 16.04 from the Google library, you need to make a custom image, to be used when you launch it. It should contain a dummy result.json file.
- Using Ruby (Rails), set up a script on the main server (which you can call with one command) that will automatically:
o Create a new simulation VM
o Once the simulation machine is up & running, upload a dummy input.json file to it from the main server
o Send back a dummy file to the main server 5 minutes later (leaves us time to verify the input.json was uploaded to the simulation VM).
o Kill the simulation VM once the file has been received by the main server

The goal:
Demonstrate this by calling the script on the main server.


Tips:
https://cloud.google.com/ruby/
