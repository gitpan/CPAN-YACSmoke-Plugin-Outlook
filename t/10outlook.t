use Test::More tests => 2;

my $mailbox = $ENV{SMOKE_MAILBOX} || 'CPAN Testers';
 
SKIP: {
	eval "use Win32::OLE::Const 'Microsoft Outlook'";
	skip "Microsoft Outlook doesn't appear to be installed", 2	if($@);

	eval "use CPAN::YACSmoke::Plugin::Outlook";
	skip "Unable to establish a connection with Outlook", 2	if($@);

	my $plugin;
	my $self = { mailbox => $mailbox };

	$plugin = CPAN::YACSmoke::Plugin::Outlook->new($self);
	skip "Mailbox '$mailbox' doesn't appear to exist", 2	if($@);

	isa_ok($plugin,'CPAN::YACSmoke::Plugin::Outlook');

	my @list = $plugin->download_list();
	ok(@list > 0);
}

