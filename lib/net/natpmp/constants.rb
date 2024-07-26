# frozen_string_literal: true

module Net
  module NATPMP
    module Constants
      VERSION = 0

      PROTO_CODES = {
        udp: :map_udp,
        tcp: :map_tcp
      }.freeze

      OP_CODES = {
        address: 0,
        map_udp: 1,
        map_tcp: 2
      }.freeze

      # 0 - Success
      # 1 - Unsupported Version
      # 2 - Not Authorized/Refused
      #     (e.g., box supports mapping, but user has turned feature off)
      # 3 - Network Failure
      #     (e.g., NAT box itself has not obtained a DHCP lease)
      # 4 - Out of resources
      #     (NAT box cannot create any more mappings at this time)
      # 5 - Unsupported opcode
      RESULT_CODES = {
        success: 0,
        unsupported_version: 1,
        not_authorized: 2,
        network_failure: 3,
        out_of_resources: 4,
        unsupported_opcode: 5
      }.freeze

      RESULT_CODES_DESC = {
        1 => 'Unsupported Version',
        2 => 'Not Authorized/Refused',
        3 => 'Network Failure',
        4 => 'Out of resources',
        5 => 'Unsupported opcode'
      }.freeze

      # This is the initial delay before doubling it
      BASE_DELAY = 0.25
      MAX_WAIT = 60

      DEFAULT_INSIDE_PORT = 0
      DEFAULT_OUTSIDE_PORT = 0
      DEFAULT_LIFETIME = 7200
      DEFAULT_PROTO = :udp
    end
  end
end
