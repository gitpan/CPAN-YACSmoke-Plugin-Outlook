use Test::More tests => 1;

eval "use Win32::OLE::Const 'Microsoft Outlook'";
SKIP: {
	skip "Microsoft Outlook doesn't appear to be installed\n", 1	if($@);

	use_ok( 'CPAN::YACSmoke::Plugin::Outlook' );
}
