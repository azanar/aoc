use strict;
use warnings;
use diagnostics;

use English;

use Data::Dumper;

my $valid = 0;

while(my $line = <>) {
    $line =~ /^(?<low>\d+)-(?<high>\d+) (?<ch>[a-z]): (?<pw>[a-z]+)$/;

    my %match = %LAST_PAREN_MATCH;


    my $chrs = $match{pw} =~ s/[^{$match{ch}}]//gr;

    my @chrsarr = split //,$chrs;

    my $chrscnt = @chrsarr;

    print "Matching $chrscnt chr $match{ch} ($match{low} -- $match{high}) in $match{pw}\n";

    if ($chrscnt >= $match{low} && $chrscnt <= $match{high}) {
        print "+";
        $valid++;
    }
}

print $valid;
