# add a python path
import ipcalc
import netifaces
import six
from optparse import OptionParser
from netaddr import IPAddress


# get some data from the user.
parser = OptionParser()
parser.add_option("-i", "--interface", action="store", dest="interface", default="eth0",
                  help="Enter a network interface name [defaults to eth0].")
(options, args) = parser.parse_args()

print options.interface

myinterface = options.interface

#  determine interface and ip/netmask info
interface_dump = netifaces.ifaddresses(myinterface)[netifaces.AF_INET]

print interface_dump

ipaddress = str(interface_dump[0]["addr"])
netmask = str(interface_dump[0]["netmask"])
cidr = str(IPAddress(netmask).netmask_bits())
ip_combined = ipaddress + '/' + cidr
network = ipcalc.Network(ip_combined).network()


print ipaddress
print netmask
print cidr
print ip_combined
print network

# blerg:w













