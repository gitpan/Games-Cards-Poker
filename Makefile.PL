use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# # the contents of the Makefile that is written.
WriteMakefile(
  'NAME'         => 'Games::Cards::Poker',
  'VERSION'      => '1.0.44F2Q8F',
  'ABSTRACT'     => 'Perl Poker functions',
  'AUTHOR'       => 'Pip Stuart <Pip@CPAN.Org>',
  'EXE_FILES'    => [ 
                    ],
  'PREREQ_PM'    => {
    'Math::BaseCnv'                  => 0,
    'Games::Cards'                   => 0,
  }, # Module::Name => 1.1,
  'dist'         => { 'COMPRESS' => 'gzip', 'SUFFIX' => 'tgz' },
);