use Test::More tests => 2;

eval "use Win32::OLE";
plan skip_all => "Win32::OLE required for testing Oulook plugin" if $@;


use CPAN::YACSmoke::Plugin::Outlook;

my $plugin;
my $self  = {
	mailbox => 'CPAN Testers'
};

eval { $plugin = CPAN::YACSmoke::Plugin::Outlook->new($self); };
SKIP: {
	skip "Unable to establish a connection with Outlook", 2	if($@);
	isa_ok($plugin,'CPAN::YACSmoke::Plugin::Outlook');

	my @list = $plugin->download_list();
	ok(@list > 0);
}

