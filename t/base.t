#!perl

use strict;
use warnings;
use Test::More tests => 8;
use Sys::HostIP qw/ip ips ifconfig interfaces/;

my $class = 'Sys::HostIP';

# -- ip() --
my $sub_ip   = ip();
my $class_ip = $class->ip;

ok( $class_ip =~ /^ \d+ (?: \. \d+ ){3} $/x, 'IP by class looks ok' );
is( $class_ip, $sub_ip, 'IP by class matches IP by sub' );

# -- ips() --
my $class_ips = $class->ips;
isa_ok( $class_ips, 'ARRAY', 'scalar context ips() gets arrayref' );
ok( 1 == grep( /^$class_ip$/, @{$class_ips} ), 'Found IP in IPs by class' );

# skipping in case it's MSWin32 or cygwin?
SKIP: {
    skip 'Issues on Windows' => 1 if $^O =~ /(MSWin32|cygwin)/;
    ok(
        1 == grep( /^127\.0\.0\.1$/, @{$class_ips} ),
        'Found 127.0.0.1 once in IPs by class',
    );
};

# -- interfaces() --
my $interfaces = $class->interfaces;
isa_ok( $interfaces, 'HASH', 'scalar context interfaces gets hashref' );
cmp_ok(
    scalar keys ( %{$interfaces} ),
    '==',
    scalar @{$class_ips},
    'Matching number of interfaces and ips',
);

# skipping in case it's MSWin32 or cygwin?
SKIP: {
    skip 'Issues on Windows' => 1 if $^O =~ /(MSWin32|cygwin)/;
    ok(
        grep( /^127\.0\.0\.1$/, values %{$interfaces} ),
        'Found 127.0.0.1 in interfaces',
    );
};
