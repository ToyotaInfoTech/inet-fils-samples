//
// Example OMNeT++ network to test WLAN Fast Initial Link Setup feature
//
// Copyright (C) 2023 TOYOTA MOTOR CORPORATION. ALL RIGHTS RESERVED.
//

package grid;

import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import inet.visualizer*.integrated.IntegratedVisualizer;
import inet.environment.common.PhysicalEnvironment;
import inet.node.inet.AccessPointFils;
import inet.node.inet.StandardHost;
import inet.node.ethernet.Eth10G;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.Router;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import org.car2x.veins.subprojects.veins_inet.VeinsInetCar;
import org.car2x.veins.subprojects.veins_inet.VeinsInetManager;
import org.car2x.veins.visualizer.roads.RoadsCanvasVisualizer;

network Scenario
{
    parameters:
        double playgroundSizeX @unit(m);
        double playgroundSizeY @unit(m);
        double playgroundSizeZ @unit(m);
        @display("bgb=1800,1500");
    submodules:
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=-200,500");
        }
        manager: VeinsInetManager {
            @display("p=1667.523,478.94598;is=s");
        }        
        configurator: Ipv4NetworkConfigurator {
            @display("p=-200,412");
        }
        visualizer: IntegratedVisualizer {
            @display("p=-200,300");
        }
        physicalEnvironment: PhysicalEnvironment {
            @display("p=-200,200");
        }
        accessPoint0: AccessPointFils {
            @display("p=0,500");
        }
        accessPoint1: AccessPointFils {
            @display("p=500,500");
        }
        accessPoint2: AccessPointFils {
            @display("p=1000,500");
        }
        wifiRouter: Router {
            @display("p=650,700");
        }
        ethernetSwitch: EtherSwitch {
            @display("p=800,700");
        }
        dhcpServer: StandardHost {
            @display("p=1110,678");
        }
        authServer: StandardHost {
            @display("p=1149,606.08");
        }
        filsAuthServer: StandardHost {
            @display("p=1059,762.496");
        }
        filsDhcpServer: StandardHost {
            @display("p=993,828");
        }
        mediaServer: StandardHost {
            @display("p=912,879");
        }
        roadsCanvasVisualizer: RoadsCanvasVisualizer {
            @display("p=1667.523,751.37396");
        }        
        car[0]: VeinsInetCar;

    connections allowunconnected:
        wifiRouter.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;        
        accessPoint0.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;
        accessPoint1.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;
        accessPoint2.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;
        dhcpServer.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;
        authServer.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;
        filsDhcpServer.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;
        filsAuthServer.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;
        mediaServer.ethg++ <--> Eth10G <--> ethernetSwitch.ethg++;        
}


