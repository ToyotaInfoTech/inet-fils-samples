# IEEE 802.11ai FILS Simulation Package: Documentation and Sample Scenarios

INET-FILS (https://github.com/ToyotaInfoTech/inet-fils) is a fork of OMNeT++ INET Framework (https://inet.omnetpp.org). On top of the original INET's implementation of IEEE 802.11 protocol stack, it adds new features to simulate IEEE 802.11ai Fast Initial Link Setup (FILS). 

This repository includes documentation and sample simulation scenarios to test INET-FILS.

Note: INET-FILS is still under active development. There is no guarantee that models available in this simulation package are fully compliant with the corresponding specifications. Please carefully review the models to make sure that they fulfil the requirements of your simulations. 

## Install

### Requirements

Similar to the original INET Framework, INET-FILS is a model library for the OMNeT++ simulation environment. The sample scenarios additionally use the road traffic simulator SUMO to simulate realistic vehicle mobility in network simulations.

Follow the documentations of OMNeT++ and SUMO to install them. 

* OMNeT++ 5.6.2 (https://omnetpp.org)
* SUMO 1.8.0 (https://eclipse.dev/sumo/)

### Clone the repository along with all the submodoles

```
git clone --recursive git@github.com:ToyotaInfoTech/inet-fils-samples
```

### Import projects into OMNeT++ workspace

The sample scenarios use the Veins framework (https://veins.car2x.org) to couple OMNeT++ with SUMO for integrated simulations of vehicle mobility and their wireless communications. Veins should have been already cloned in the previous step. The next step is to import Veins into your OMNeT++ workspace along with INET-FILS and its samples. 

* Launch OMNeT++ IDE and create a new workspace. 
* From the top menu bar, select `File->Import->General->Existing Projects into Workspace` and click `Next`.
* On the `Import` window:
    * Select `/path/to/inet-fils-samples` as the root directory. 
    * In the `Options` section, tick `Search for nested projects`. 
    * In the `Projects` section, tick the following projects:
        * `inet`
        * `samples`
        * `veins`
        * `veins_inet`
    * Click `Finish`. 

### Build

* Change build configurations  to `Release` mode. This can be done by right-clicking each project in the Project Explorer pane, then selecting `Build Configurations->Set Active->release`. 
* On the OMNeT++ IDE, select `Project->Build All` from the top menu bar to build the entire workspace. If you encounter any error, try cleaning all projects before building. 

## Run

* Open a new terminal and launch SUMO
```
/path/to/inet-fils-samples/veins/veins_launchd
```
* In the `Project Explorer` pane of OMNeT++ IDE, right-click on `samples/grid/omnetpp.ini`. 
* `Run As->OMNeT++ Simulation` to open a simulation window. 
* Select one of the following configurations and click `OK`. 
    * `RegularEAP`: disable FILS
    * `FILS`: enable FILS
* Click `RUN` or `FAST` icon to start a simulation. One vehicle travels on an "8"-shaped loop and connect to three WLAN access points along its path. Once a WLAN link is established with an access point, the vehicle repeatedly exchange data messages with a remote content server via the access point. 

## Implementation Overview

In the current version of INET-FILS, WLAN stations, access points and an authentication server use UDP to exchange messages during initial link setup. This is a tentative solution for ease of implementation - in a future version, WLAN authentication and IP address assignment shall be implemented on a lower layer of the network stack to make them better aligned with specifications. 

### Link setup with Regular EAP

Four applications are hosted on each WLAN station and communicate with a DHCP server, an authentication server or a content server. 
* `app[0]`: upon successful completion of association, it notifies `app[1]` to initiate DHCP message exchange. 
* `app[1]`: exchange messages with a DHCP server. When receiving a DHCP ACK, it notifies `app[2]` to initiate EAP authentication. (The order of `app[1]` and `app[2]` should be switched in the future version. See ToDo section.)
* `app[2]`: exchange messages with an authentication server. Upon successful completion of EAP authentication, it notifies `app[3]` to initiate transfer of user data traffic. 
* `app[3]`: this is an example application that generates user data traffic. It repeatedly exchanges UDP packets with a remote content server via the WLAN access point. 

### Link setup with FILS

To enable FILS features, an access point hosts the following application that intermediates message exchange among WLAN stations, an authentication server and a DHCP server. 

* `app[0]`: upon receiving an Authentication Request from a WLAN station, it initiates authentication with an authentication server. When receiving an Association Request from a WLAN station, it communicates with a DHCP server to obtain an IP address on behalf of the station. 

WLAN stations run the same set of applications as Regular EAP, while two of the four applications are not used when FILS is enabled. 

* `app[0]`: upon successful completion of association, it notifies `app[3]` to initiate transfer of user data traffic. 
* `app[1]`: unused
* `app[2]`: unused
* `app[3]`: this is an example application that generates user data traffic. It repeatedly exchanges UDP packets with a remote content server via the WLAN access point. 

## ToDo
* Rebase INET-FILS onto the latest version of INET. It is currently based on INET 4.2.2, hence it works only on older versions of OMNeT++. 
* Implement EAP on a lower layer of the network stack rather than on the application layer. 
* In the link setup with regular EAP, DHCP messages should be exchanged AFTER successfull completion of EAP authentication (i.e., the order of app[1] and app[2] should be switched).