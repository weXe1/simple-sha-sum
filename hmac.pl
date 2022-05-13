#!/usr/bin/perl
use strict;
use warnings;
use Digest::SHA;
use Getopt::Long;

my ($alg, $key, $file, $hmac);

my $usage = "\$ perl $0 -f <file> [-hmac] [-a <1|224|256|384|512>] [-k <key>]\n";

GetOptions(
    'a|algorithm=i' => \$alg,
    'k|key=s' => \$key,
    'f|file=s' => \$file,
    'h|hmac' => \$hmac
);

unless (defined $file) {
    die $usage;
}

unless (defined $alg) {
    $alg = 256;
}

unless ($alg =~ /1|224|256|384|512/) {
    die $usage;
}

unless (defined $key) {
    $key = '';
}

my $data;

{
    open my $fh, '<', $file or die "$!: $file\n";
    local $/ = undef;
    $data = <$fh>;
    close $fh;
}

if ($hmac) {
    my $func;
    eval '$func = \&Digest::SHA::hmac_sha'.$alg.'_hex';

    my $mac = &$func($data, $key);

    print "HMAC (SHA$alg) = $mac $file\n";
}
else {
    my $sha = Digest::SHA->new($alg);
    $sha->add($data);

    my $digest = $sha->hexdigest;
    print "SHA$alg = $digest $file\n";
}
