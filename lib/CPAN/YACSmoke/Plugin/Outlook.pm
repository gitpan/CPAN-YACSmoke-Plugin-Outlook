package CPAN::YACSmoke::Plugin::Outlook;

use strict;

our $VERSION = '0.07';

# -------------------------------------

=head1 NAME

CPAN::YACSmoke::Plugin::Outlook - Outlook mailbox list for CPAN::YACSmoke

=head1 DESCRIPTION

IMPORTANT NOTES: 

  1) CPAN::YACSmoke is no longer supported.
  2) The recommend CPANPLUS smoker is now CPANPLUS-Smoker.
  3) The NNTP feed has now been disabled. 
  4) The CPAN Testers mailing list has now been disabled. 

As such this module will be removed from CPAN in January 2011.

Reads the mail folder within Outlook, containing the mail from the 
cpan-testers mailing list, extracts the subject headings of all the 
PAUSE posts, and generates a list of modules, which require testing.

This module should be use together with CPAN::YACSmoke.

=head1 SYNOPSIS

  use CPAN::YACSmoke;
  my $config = {
      list_from => 'Outlook', 
      mailbox => 'CPAN Testers' # no default, must be set.
  };
  my $foo = CPAN::YACSmoke->new(config => $config);
  my @list = $foo->download_list();

=cut

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
    my $class = shift;
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

#=item _getFolder()
#
# Read the mail folder within Outlook and return an object
# reference to it.
#
# The function may be rewritten in the future to use the
# Mail::Outlook module. For now it is enough to wrap it here.
#
#=cut

sub _getFolder{
    my $mailbox = shift;
    my ($outlook,$folder);

    eval { $outlook = Win32::OLE->GetActiveObject('Outlook.Application') };
    if ($@ || !defined($outlook)) {
        eval { $outlook = Win32::OLE->new('Outlook.Application', sub {$_[0]->Quit;}) };
        return  if ($@ || !defined($outlook));
    }

    my $namespace = $outlook->GetNameSpace("MAPI")              or return;
    my $inbox     = $namespace->GetDefaultFolder(olFolderInbox) or return;

    eval { $folder = $inbox->Folders($mailbox) };
    return  if($@);

    return $folder;
}

#=item _getTestList()
#
# Read the messages within $folder and create a list of distributions to test.
#
#=cut

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

            if(my ($extn) = ($file =~ /(\.tar(?:\.(?:gz|Z|bz2))?|\.t[gb]z|\.zip)$/i)) {
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
                                    !x);
                # Did we manage to parse it?
                push @testlist, $path   if($dist);
            }
        }
    } while ($item = $items->GetPrevious());

    return @testlist;
}

1;
__END__

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

=head1 SUPPORT

There are no known bugs at the time of this release. However, if you spot a
bug or are experiencing difficulties that are not explained within the POD
documentation, please submit a bug to the RT system (see link below). However,
it would help greatly if you are able to pinpoint problems or even supply a 
patch. 

Fixes are dependant upon their severity and my availablity. Should a fix not
be forthcoming, please feel free to (politely) remind me by sending an email
to barbie@cpan.org .

RT: http://rt.cpan.org/Public/Dist/Display.html?Name=CPAN-YACSmoke-Plugin-Outlook

=head1 SEE ALSO

CPAN Testers Reports - L<http://www.cpantesters.org>

CPAN Testers Wiki - L<http://wiki.cpantesters.org>

CPAN Testers Blog - L<http://blog.cpantesters.org>

CPAN Testers Development - L<http://devel.cpantesters.org>

CPAN Testers Statistics - L<http://stats.cpantesters.org>

For additional information, see the documentation for these modules:

  CPANPLUS
  Test::Reporter
  CPAN::YACSmoke

  Win32::OLE
  Win32::OLE::Const 'Microsoft Outlook'
  File::Basename

=head1 DSLIP

  b - Beta testing
  d - Developer
  p - Perl-only
  O - Object oriented
  p - Standard-Perl: user may choose between GPL and Artistic

=head1 AUTHOR

Barbie <barbie@cpan.org>
for Miss Barbell Productions http://www.missbarbell.co.uk.

=head1 COPYRIGHT AND LICENSE

  Copyright (C) 2005-2010 Barbie for Miss Barbell Productions.

  This module is free software; you can redistribute it and/or
  modify it under the Artistic Licence v2.

=cut