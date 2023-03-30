
package EFI::Util;

use strict;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.00;
@ISA         = qw(Exporter);
@EXPORT      = ();
@EXPORT_OK   = qw(usesSlurm getSchedulerType getLmod defaultScheduler validateConfigFile checkNetworkType);


sub usesSlurm {
    my $usesSlurm = `which sbatch 2>/dev/null`;
    if (length $usesSlurm > 0) {
        return 1;
    } else {
        return 0;
    }
}

sub getSchedulerType {
    my $scheduler = shift;
    if ($scheduler and $scheduler eq "torque") {
        return "torque";
    } else {
        return defaultScheduler();
    }
}

sub defaultScheduler {
    return "slurm";
}

sub getLmod {
    my ($pattern, $default) = @_;

    use Capture::Tiny qw(capture);

    my ($out, $err) = capture {
        `source /etc/profile; module -t avail`;
    };
    my @py2 = grep m{$pattern}, (split m/[\n\r]+/s, $err);

    return scalar @py2 ? $py2[0] : $default;
}

sub checkNetworkType {
    my $file = shift;

    my $type = "UniProt";
    my $isDomain = 0;

    my $text = "";
    if ($file =~ m/\.zip$/i) {
        $text = `unzip -p $file | head -1000`;
    } else {
        $text = `head -1000 $file`;
    }

    $isDomain = ($text =~ m/<node[^>]+label=["'][^"':]+:\d/s);
    if ($text =~ m/<att[^>]+name=["'](UniRef([59]0))/s) {
        $type = $1 if ($1 and ($2 eq "50" or $2 eq "90"));
    }

    # BAD CODE, DON'T USE:
    #    open my $fh, "<", $file or die "Unable to check network type for $file: $!";
    #    while (my $line = <$fh>) {
    #        if (not defined $isDomain and $line =~ m/DOM_yes/) {
    #            $isDomain = 1;
    #        }
    #        if (not $type and $line =~ m/UniRef([59]0)/) {
    #            $type = "UniRef$1";
    #        }
    #        last if (defined $isDomain and $type);
    #    }
    #    $type = "UniProt" if not $type;
    #    $isDomain = 0 if not defined $isDomain;

    return ($type, $isDomain);
}

1;

