use Test::More;
use IO::File;

# Skip if doing a regular install
plan skip_all => "Author tests not required for installation"
    unless ( $ENV{AUTOMATED_TESTING} );

my $fh = IO::File->new('Changes','r')   or plan skip_all => "Cannot open Changes file";

plan no_plan;

SKIP: {
	eval "use Typelibs";
	skip "Microsoft Outlook doesn't appear to be installed\n", 1	if($@);

	my $vers = Typelibs::ExistsTypeLib('Microsoft Outlook');
	skip "Microsoft Outlook doesn't appear to be installed\n", 1	unless($vers);

	use_ok( 'CPAN::YACSmoke::Plugin::Outlook' );

    my $version = $CPAN::YACSmoke::Plugin::Outlook::VERSION;

    my $latest = 0;
    while(<$fh>) {
        next        unless(m!^\d!);
        $latest = 1 if(m!^$version!);
        like($_, qr!\d[\d._]+\s+\d{2}/\d{2}/\d{4}!,'... version has a date');
    }

    is($latest,1,'... latest version not listed');
}

$fh->close;
