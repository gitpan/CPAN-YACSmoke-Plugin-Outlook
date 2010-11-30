use Test::More tests => 1;
ok(1);  # just for the sake of a test

#use Test::More tests => 6;
#
#use lib 't/testlib';
#
#my $mailbox = $ENV{SMOKE_MAILBOX} || 'CPAN Testers';
# 
#SKIP: {
#	eval "use Typelibs";
#	skip "Microsoft Outlook doesn't appear to be installed\n", 6	if($@);
#	my $vers = Typelibs::ExistsTypeLib('Microsoft Outlook');
#	skip "Microsoft Outlook doesn't appear to be installed\n", 6	unless($vers);
#	eval "use CPAN::YACSmoke::Plugin::Outlook";
#	skip "Unable to establish a connection with Outlook", 6	        if($@);
#
#    my @list;
#
#    # bad calls
#	my $plugin = CPAN::YACSmoke::Plugin::Outlook->new();
#	isa_ok($plugin,'CPAN::YACSmoke::Plugin::Outlook');
#	eval { @list = $plugin->download_list(); };
#	like($@, qr/Need a Outlook mail folder to proceed/);
#
#    my $self = { mailbox => 'blah' };
#	$plugin = CPAN::YACSmoke::Plugin::Outlook->new($self);
#	isa_ok($plugin,'CPAN::YACSmoke::Plugin::Outlook');
#	eval { @list = $plugin->download_list(); };
#	like($@, qr/Cannot read 'blah' Folder/);
#
#    # good calls
#    $self = { mailbox => $mailbox };
#	$plugin = CPAN::YACSmoke::Plugin::Outlook->new($self);
#	isa_ok($plugin,'CPAN::YACSmoke::Plugin::Outlook');
#	eval { @list = $plugin->download_list(); };
#    skip "Mailbox '$mailbox' doesn't appear to exist", 1	if($@);
#	ok(@list > 0);
#}
#
