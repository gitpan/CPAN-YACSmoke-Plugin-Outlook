=head1 NAME

CPAN::YACSmoke::Plugin::Outlook - Outlook mailbox list for Yet Another CPAN Smoke Tester

=head1 SYNOPSIS

  use CPAN::YACSmoke;
  my $config = {
	  list_from => 'Outlook', 
      mailbox => 'CPAN Testers' # no default, must be set.
  };
  my $foo = CPAN::YACSmoke->new(config => $config);
  my @list = $foo->download_list();

=head1 DESCRIPTION

Reads the mail folder within Outlook, containing the mail from the 
cpan-testers mailing list, extracts the subject headings of all the 
PAUSE posts, and generates a list of modules, which require testing.

This module should be use together with CPAN::YACSmoke.

=cut

package CPAN::YACSmoke::Plugin::Outlook;
use strict;

our $VERSION = '0.02';

# -------------------------------------
# Library Modules

use Win32::OLE;
use Win32::OLE::Const 'Microsoft Outlook';
use File::Basename;
use Carp;

# -------------------------------------
# The Subs

=head1 CONSTRUCTOR

=over 4

=item new()

Creates the plugin object.

=back

=cut
    
sub new {
    my $class = shift || __PACKAGE__;
    my $hash  = shift;

    my $self = {};
    foreach my $field (qw( mailbox )) {
        $self->{$field} = $hash->{$field}   if(exists $hash->{$field});
    }

    bless $self, $class;
}

=head1 METHODS

=over 4

=item download_list()

Return the list of distributions currently stored in the designated mail folder.

=cut
    
sub download_list {
    my $self   = shift;
    my $mailbox = $self->{mailbox}
        or croak("Need a Outlook mail folder to proceed\n");
    my $folder = _getFolder($mailbox)   
        or croak("Cannot read '$mailbox' Folder\n");
    return _getTestList($folder);
}

=item _getFolder()

Read the mail folder within Outlook and return an object
reference to it.

=cut

# The following subroutine may be rewritten in the future to use the
# Mail::Outlook module. For now it is enough to wrap it here.

sub _getFolder{
    my $mailbox = shift;
    my $outlook;

    eval {
        $outlook = Win32::OLE->GetActiveObject('Outlook.Application')
    };
    if ($@ || !defined($outlook)) {
        $outlook = Win32::OLE->new('Outlook.Application', sub {$_[0]->Quit;})
            or return undef;
    }

    my $namespace = $outlook->GetNameSpace("MAPI")          or return undef;
    my $inbox = $namespace->GetDefaultFolder(olFolderInbox) or return undef;
    my $folder = $inbox->Folders($mailbox)                  or return undef;

    return $folder;
}

=item _getTestList()

Read the messages within $folder and create a list of distributions to test.

=cut

sub _getTestList {
    my $folder = shift;
    my $items = $folder->Items();
    my $item = $items->GetLast();

    my @testlist;

    do {
        my $subject = $item->Subject();
        if($subject =~ /^CPAN Upload: (.*)/) {
            my $path = $1;
            my $file = basename($path);

            # Only testing distributions which have been tarballed and/or
            # compressed, otherwise it is likely to be an adhoc distribution.
            # Plus CPANPLUS uses this regex anyway.

            my ($extn) = ($file =~ /(\.tar(?:\.(?:gz|Z|bz2))?|\.t[gb]z|\.zip)$/i);
            my ($dist,$version) = ($file =~ m!
                ^                       # start of string
                (.*?)                   # distribution name
                [\-_]                   # name/version separator
                (\d                     # a major version number
                    (?: [\._]           # major/minor version separator
                        \d              # minor version number
                        (?:[\-\._\w]+)? # development release id
                    )?
                )
                $extn                   # file extension
                                !x)     if($extn);
            # Did we manage to parse it?
            push @testlist, $path   if($dist && $extn);
        }
    } while ($item = $items->GetPrevious());

    return @testlist;
}

1;
__END__

=pod

=back

=head1 CAVEATS

This is a proto-type release. Use with caution and supervision.

The current version has a very primitive interface and limited
functionality.  Future versions may have a lot of options.

There is always a risk associated with automatically downloading and
testing code from CPAN, which could turn out to be malicious or
severely buggy.  Do not run this on a critical machine.

This module uses the backend of CPANPLUS to do most of the work, so is
subject to any bugs of CPANPLUS.

=head2 Suggestions and Bug Reporting

Please submit suggestions and report bugs to the CPAN Bug Tracker at
L<http://rt.cpan.org>.

=head1 SEE ALSO

The CPAN Testers Website at L<http://testers.cpan.org> has information
about the CPAN Testing Service.

For additional information, see the documentation for these modules:

  CPANPLUS
  Test::Reporter
  CPAN::YACSmoke

  Win32::OLE
  Win32::OLE::Const 'Microsoft Outlook'
  File::Basename

=head1 AUTHOR

Barbie, C< <<barbie@cpan.org>> >
for Miss Barbell Productions, L<http://www.missbarbell.co.uk>

Birmingham Perl Mongers, L<http://birmingham.pm.org/>

=head1 COPYRIGHT AND LICENSE

  Copyright (C) 2003-5 Barbie for Miss Barbell Productions
  All Rights Reserved.

  This module is free software; you can redistribute it and/or 
  modify it under the same terms as Perl itself.

=cut
