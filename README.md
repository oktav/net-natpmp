# net-natpmp
This is a NAT-PMP client implementation in ruby which allows to interact with routers that support this feature. 

If follows closely the specifications described in [RFC 6886](https://datatracker.ietf.org/doc/html/rfc6886).

## Usage

```ruby
require 'net/natpmp'

# First we need to create a client instance
# For now, the gateway needs to be specified manually.
client = Net::NATPMP.client(gw: '10.2.0.1')
```

Specifying the gateway manually is a deliberate choice as it's mainly used to set a port mapping on a router/firewall which is not part of the local network but rather a VPN which allows port forwarding through NAT-PMP. ie. ProtonVPN, PIA, NordVPN, you know the deal.

Pulling the local gateway might be a feature added later.

```ruby
# Query the remote gateway for it's external address
client.external_address
=> External address: 1.2.3.4

# Get the address as a string
client.external_address.to_s
=> "1.2.3.4"

# Let's set up a port mapping
# These arguments are the defaults. proto can be :udp or :tcp
client.map_port(proto: :udp, inside_port: 0, outside_port: 0, lifetime: 7200)
=> Port mapping: 37351 -> udp:37351 (lifetime: 60)
# The lifetime in the response is received by the remote gateway
# In this case, the gateway only allows for 60 second maps
mapping = _
=> Port mapping: 37351 -> udp:37351 (lifetime: 60)
mapping.inside_port
=> 37351
mapping.outside_port
=> 37351
mapping.proto
=> :udp
mapping.lifetime
=> 60
```

We can also destroy a mapping forcefully without waiting for it to expire

```ruby
# The protocol and port argument must match the mapping protocol
# and internal port requested initially
client.destroy_mapping(proto: :udp, port: 37351)
=> Port mapping: 0 -> udp:37351 (lifetime: 0)
```

## TODO
The protocol is extremely simple with only 2 actual querries but it would be useful to implement the following:

- Use the local default gateway of the host running the application if the gateway is not specified when creating the `Net::NATPMP` client