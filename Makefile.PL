use ExtUtils::MakeMaker;
WriteMakefile
(
    'NAME' => 'CPAN::YACSmoke::Plugin::Outlook',
    'VERSION_FROM' => 'lib/CPAN/YACSmoke/Plugin/Outlook.pm',
    'PREREQ_PM' => {
                'Test::More'            => 0,
                'CPAN::YACSmoke'        => 0.03,
				'Win32::OLE'            => 0,
				'Win32::OLE::Const'     => 0,
				'File::Basename'        => 0,
				'Carp'                  => 0,
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT	=> 'Outlook mailbox list for CPAN::YACSmoke',
       AUTHOR	=> 'Barbie <barbie@cpan.org>') : ()),
);

print <<HERE;

  Please note that Microsoft Outlook is required by this distribution.

HERE
