use Test::More;

# Skip if doing a regular install
plan skip_all => "Author tests not required for installation"
    unless ( $ENV{AUTOMATED_TESTING} );

eval "use Test::CPAN::Meta";
plan skip_all => "Test::CPAN::Meta required for testing META.yml" if $@;

plan no_plan;

my $meta = meta_spec_ok(undef,undef,@_);

SKIP: {
	eval "use Typelibs";
	skip "Microsoft Outlook doesn't appear to be installed\n", 1	if($@);

	my $vers = Typelibs::ExistsTypeLib('Microsoft Outlook');
	skip "Microsoft Outlook doesn't appear to be installed\n", 1	unless($vers);

	use_ok( 'CPAN::YACSmoke::Plugin::Outlook' );

    my $version = $CPAN::YACSmoke::Plugin::Outlook::VERSION;

    is($meta->{version},$version,
        'META.yml distribution version matches');

    if($meta->{provides}) {
        for my $mod (keys %{$meta->{provides}}) {
            is($meta->{provides}{$mod}{version},$version,
                "META.yml entry [$mod] version matches");
        }
    }
}
