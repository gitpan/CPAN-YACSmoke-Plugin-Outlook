use Test::More tests => 1;

use lib 't/testlib';

BEGIN {
SKIP: {
	eval "use Typelibs";
	skip "Microsoft Outlook doesn't appear to be installed\n", 1	if($@);

	my $vers = Typelibs::ExistsTypeLib('Microsoft Outlook');
	skip "Microsoft Outlook doesn't appear to be installed\n", 1	unless($vers);

	use_ok( 'CPAN::YACSmoke::Plugin::Outlook' );
}
}
