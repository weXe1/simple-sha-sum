#!/usr/bin/perl
use strict;
use warnings;
use Digest::SHA;
use Getopt::Long;

my ($alg, $pass, $file);

my $usage = "\$ perl $0 -f <file> [-a <1|224|256|384|512>] [-p <password>]\n";

GetOptions(
    'a|algorithm=i' => \$alg,
    'p|password=s' => \$pass,
    'f|file=s' => \$file
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

unless (defined $pass) {
    $pass = '';
}

my $data;

{
    open my $fh, '<', $file or die "$!: $file\n";
    local $/ = undef;
    $data = <$fh>;
    close $fh;
}

$data .= $pass;

my $sha = Digest::SHA->new($alg);
$sha->add($data);

my $digest = $sha->hexdigest;
print "$digest $file\n";
