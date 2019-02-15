# == Class: nova::serialproxy::common
#
# [*serialproxy_host*]
#   (optional) The host of the serial proxy server
#   Defaults to undef
#
# [*serialproxy_protocol*]
#   (optional) The protocol to communicate with the serial proxy server
#   Defaults to undef
#
# [*serialproxy_port*]
#   (optional) The port to communicate with the serial proxy server
#   Defaults to undef
#
# [*serialproxy_path*]
#   (optional) The path at the end of the uri for communication with the serial
#   proxy server
#   Defaults to undef
#
class nova::serialproxy::common (
  $serialproxy_host     = undef,
  $serialproxy_protocol = undef,
  $serialproxy_port     = undef,
  $serialproxy_path     = undef,
) {

  include ::nova::deps

  $serialproxy_host_real     = normalize_ip_for_uri(pick(
    $serialproxy_host,
    $::nova::compute::serialproxy_host,
    $::nova::serialproxy::host,
    false))
  $serialproxy_protocol_real = pick(
    $serialproxy_protocol,
    $::nova::compute::serialproxy_protocol,
    $::nova::serialproxy::serialproxy_protocol,
    'http')
  $serialproxy_port_real     = pick(
    $serialproxy_port,
    $::nova::compute::serialproxy_port,
    $::nova::serialproxy::port,
    6080)

  if ($serialproxy_host_real) {
    $serialproxy_base_url = "${serialproxy_protocol_real}://${serialproxy_host_real}:${serialproxy_port_real}"
    # config for serial proxy
    nova_config {
      'serial_console/base_url': value => $serialproxy_base_url;
    }
  }
}
