use ExtUtils::MakeMaker;
WriteMakefile
(
    'NAME' => 'CPAN::YACSmoke::Plugin::Outlook',
    'VERSION_FROM' => 'lib/CPAN/YACSmoke/Plugin/Outlook.pm',
    'PREREQ_PM' => {
                'Test::More'            => 0,
                'CPAN::YACSmoke'        => '0.02_03',
				'Win32::OLE'            => 0,
				'Win32::OLE::Const'     => 0,
				'File::Basename'        => 0,
				'Carp'                  => 0,
    },
    'INSTALLDIRS' => 'site',
    'PL_FILES' => {}
);
