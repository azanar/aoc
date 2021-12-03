use strict;
use warnings;
use diagnostics;

use English;

use Data::Dumper;

my $valid = 0;

while(my $line = <>) {
    $line =~ /^(?<low>\d+)-(?<high>\d+) (?<ch>[a-z]): (?<pw>[a-z]+)$/;

    my %match = %LAST_PAREN_MATCH;

    my @chrsarr = split //,$match{pw};

    my @locs = ();

    for my $idx (0..$#chrsarr) { 
        my $ch = $chrsarr[$idx];

        next unless ($ch eq $match{ch});

        push(@locs, $idx+1); 
    }

    my %locmap = map {$_ => 1} @locs;

    if (defined $locmap{$match{low}} != defined $locmap{$match{high}}) {
        $valid++;
    }
}

print $valid;
